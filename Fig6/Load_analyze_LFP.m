%% load RC+S data
recordings_all = cell(length(dates),1);
lfp_dir_temp = cell(length(dates),1);
num_recs = zeros(length(dates),1);
for i = 1:length(dates)
    date = dates{i};
    % get LFP directory
    lfp_dir = ['D:\OCD-Patient-Data\', subject_id, '\at-home\',date,'\LFP\'];

    % if it doesn't exist, then run the LFP organization script
    if ~exist(lfp_dir)
        move_lfp_to_date_folder_home;
    end

    % if it still doesn't exist
    if ~exist(lfp_dir)
        error('No LFP file found. Check box.')
    end

    % get the device name
    % fill out serial numbers of subject's RC+S devices here
    % format: 'DeviceNPC...."
    addpath(lfp_dir);
    if strcmp(subject_id,'aDBS005')
        device_name = '';
    elseif strcmp(subject_id,'aDBS004')
        device_name = '';
    elseif strcmp(subject_id,'aDBS007')
        device_name = '';
    end

    %extract the recordings
    recordings = dir(lfp_dir);
    recordings = recordings(startsWith(string({recordings.name}), 'Session'));
    recordings_all{i} = recordings;
    lfp_dir_temp{i} = lfp_dir;
    num_recs(i) = length(recordings);
end

% finalize list of all session folders on specified dates
recordings_all = cell2mat(recordings_all);
lfp_dir_all = cell(length(recordings_all),1);
for i = 1:length(dates)
    if i == 1
        lfp_dir_all(1:num_recs(i)) = repmat(lfp_dir_temp(i),[num_recs(i),1]);
    else
        lfp_dir_all(sum(num_recs(1:(i-1)))+1:sum(num_recs(1:i))) = repmat(lfp_dir_temp(i),[num_recs(i),1]);
    end
end
    
%% Load LFP data

addpath(genpath('D:\Libraries\Analysis-rcs-data-master-May2021\Analysis-rcs-data-master'))

Load_Symptom_data_ERP_all;

for i = 1:length(lfp_dir_all)
    savedir = [results_path,'/data/',recordings_all(i).name,'.mat'];
    if ~exist(savedir)
        fn = [lfp_dir_all{i},recordings_all(i).name,'\',device_name,'\'];

        [unifiedDerivedTimes,...
        timeDomainData, timeDomainData_onlyTimeVariables, timeDomain_timeVariableNames,...
        AccelData, AccelData_onlyTimeVariables, Accel_timeVariableNames,...
        PowerData, PowerData_onlyTimeVariables, Power_timeVariableNames,...
        FFTData, FFTData_onlyTimeVariables, FFT_timeVariableNames,...
        AdaptiveData, AdaptiveData_onlyTimeVariables, Adaptive_timeVariableNames,...
        timeDomainSettings, powerSettings, fftSettings, eventLogTable,...
        metaData, stimSettingsOut, stimMetaData, stimLogSettings,...
        DetectorSettings, AdaptiveStimSettings, AdaptiveEmbeddedRuns_StimSettings] = ProcessRCS(fn);

        [combinedDataTable] = createCombinedTable({timeDomainData,AccelData},...
            unifiedDerivedTimes,metaData);
        save(savedir,'combinedDataTable','metaData')
    else
        load(savedir)
    end
    plot(hours(combinedDataTable.localTime-SUDS.times(1)),9.8*ones(size(combinedDataTable.localTime)),'Color',lfp_color,'LineWidth',10)
    hold on
    first_time = combinedDataTable.localTime(1);
        last_time = combinedDataTable.localTime(end);
        relevant_SUDS_inds = find(and(SUDS.times > first_time,SUDS.times<last_time));
        for l = 1:length(relevant_SUDS_inds)
            m = relevant_SUDS_inds(l);
            
            % get SUDS time and rating
            suds_time = SUDS.times(m);
            suds_rating = SUDS.ratings(m);
            
            % define time period (1 minute before and 1 minute after rating
            % submbission
            start_time = suds_time - minutes(1);
            end_time = suds_time + minutes(1);
            
            % Gather LFP data during that time and plot
            [val, I_start] = min(abs(combinedDataTable.localTime - start_time));
            [val, I_end] = min(abs(combinedDataTable.localTime - end_time));
            
            lfp1 = combinedDataTable.TD_key0(I_start:I_end);
            lfp2 = combinedDataTable.TD_key2(I_start:I_end);
            lfp_times = combinedDataTable.localTime(I_start:I_end);
            

            % Find mean of all data and subtract for baseline correction
            mean_lfp1 = nanmean(lfp1);
            mean_lfp2 = nanmean(lfp2);
            
            lfp1 = lfp1' - mean_lfp1;
            lfp2 = lfp2' - mean_lfp2;
                       
            % Gather contiguous segments-----------------------------------
            nanInds=find(isnan(lfp1));
            index=find(~isnan(lfp1));
            idx=find(diff(index)~=1);
            
            if ~isempty(idx)
                A=[idx(1),diff(idx),numel(index)-idx(end)];
                
                % gather contiguous segments
                C1=mat2cell(lfp1(index),1,A);
                C2=mat2cell(lfp2(index),1,A);
                
                % window size = 125 (1/2 second for 250hz recordings)
                win=250;
                ovl=floor(win/2);
                C1=C1(A>win);
                C2=C2(A>win);
                count=0;
                
                % define count: number of windows within contiguous
                % segments
                for k=1:length(C1)
                    j=1;
                    while j+win<length(C1{k})
                        count=count+1;
                        j=j+ovl;
                    end
                end
                                
            % Window into 1s long segments and plot all-----------------            
            % Compute PSDs, plot all
                psdMat1=zeros(count,length(f1));
                psdMat2=zeros(count,length(f1));
                ind=1;
                for k=1:length(C1)
                    j=1;
                    std_dist1 = [];
                    std_dist2 = [];
                    while j+win<length(C1{k})
                        psdMat1(ind,:)=pwelch(C1{k}(j:j+win),hamming(win),ovl,f1,250);
                        psdMat2(ind,:)=pwelch(C2{k}(j:j+win),hamming(win),ovl,f1,250);
                        
                        % get std distributions of all windows
                        std_dist1(ind) = std(C1{k}(j:j+win));
                        std_dist2(ind) = std(C1{k}(j:j+win));
                        
                        ind=ind+1;
                        j=j+ovl;
                    end
                end
                            
                mean_psd1 = median(psdMat1);
                mean_psd2 = median(psdMat2);
                
            suds_time_temp = SUDS.times(m);
            suds_rating_temp = SUDS.ratings(m);

            % Save
            save_fn = [results_path,results_name,recordings_all(i).name,'_',num2str(l),'.mat'];
            save(save_fn,'mean_psd1','mean_psd2','psdMat1','psdMat2','lfp1','lfp2','suds_time_temp',...
            'suds_rating_temp');
        
            % Save figure of mean PSD
             fig = figure; 
                subplot(1,2,1)
                hold on
                plot(f1,10*log10(mean_psd1/mean(mean_psd1(f1>4&f1<80))))
                plot(f1,10*log10(mean_psd2/mean(mean_psd2(f1>4&f1<80))))
                xlim([4,80])
                subplot(1,2,2)
                hold on
                plot(f1,(mean_psd1/mean(mean_psd1(f1>4&f1<80))))
                plot(f1,(mean_psd2/mean(mean_psd2(f1>4&f1<80))))
                xlim([4,80]) 
                title(['SUDS: ',num2str(suds_rating_temp)])
                
            saveas(fig,[results_path,'/resultsERP/figures/',recordings_all(i).name,'_',num2str(l),'_PSD.png'])
            close(fig);
            end            
    end
end

saveas(gcf,[results_path,'/',results_name,'/sprint_symptom_figure.svg'])
saveas(gcf,[results_path,'/',results_name,'/sprint_symtpom_figure.png'])
 
saveas(gcf,[figure_path,'/suds_v_time/',subject_id,'_',date_str_i,'_','sprint_symtpom_figure.png']);

