% set path to folder that contains data and a results folder

data_path = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\Fig6\';
results_path = 'C:\Users\Nicol\OneDrive\Documents\Results\';
final_figure_path = 'C:\Users\Nicol\OneDrive\Documents\Results\Fig6\';

%% set paths
% specify subject ID
subject_id = 'P4';

data_folder = [data_path,'ratings\'];
addpath(genpath(data_folder));
LFP_data_folder = [data_path,'P4-LFP-anon\'];
addpath(genpath(LFP_data_folder));
addpath(genpath(results_path));
wd = pwd;
addpath(genpath(wd))
% set and add path to where figures will be saved
figure_path = [results_path,subject_id,'/figures/'];
if ~exist(figure_path)
    mkdir(figure_path)
end
addpath(genpath(figure_path))

% set results folder name
results_name = [results_path,subject_id,'\resultsSprint_',subject_id,'\'];
addpath(genpath(results_name));

if ~exist([results_name])
    mkdir([results_name]);
end
    
% list of frequencies for spectral power analysis
load('frequency.mat')

% plotting color
lfp_color = [255,127,0]/255;

%% fill in session info (USER INPUT)
dates = {'2021-05-03';'2021-05-04';'2021-05-05'};

%% load RC+S data

lfp_dir_all = dir(LFP_data_folder);
lfp_dir_all = lfp_dir_all(startsWith(string({lfp_dir_all.name}), 'Session'));

%% Load LFP data

Load_Symptom_data;

if ~exist([results_name,'/data/'])
    mkdir([results_name,'/data/']);
end

LFP_path = [data_path,subject_id,'-LFP-anon/'];
if ~exist(LFP_path)
    mkdir(LFP_path)
end
for i = 1:length(lfp_dir_all)
    savedir = [LFP_path,lfp_dir_all(i).name];
    load(savedir)
    
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
                
            % Frequency domain outlier detection
                o1=abs(mean(psdMat1(:,f1>4&f1<8),2)-mean(mean(psdMat1(:,f1>4&f1<8),2)))>2*std(mean(psdMat1(:,f1>4&f1<8),2));
                o2=abs(mean(psdMat2(:,f1>4&f1<8),2)-mean(mean(psdMat2(:,f1>4&f1<8),2)))>2*std(mean(psdMat2(:,f1>4&f1<8),2));
            % Time domain outlier detection
                ol1 = isoutlier(std_dist1,'median','ThresholdFactor',4);
                ol2 = isoutlier(std_dist2,'median','ThresholdFactor',4);
            % Mean PSD
                %mean_psd1 = median(psdMat1(~ol1,:));
                %mean_psd2 = median(psdMat2(~ol2,:));
                mean_psd1 = median(psdMat1);
                mean_psd2 = median(psdMat2);
                
            suds_time_temp = SUDS.times(m);
            suds_rating_temp = SUDS.ratings(m);

            % Save
            save_fn = [results_name,'/data/',lfp_dir_all(i).name(1:(end-4)),'_',num2str(l),'.mat'];
            save(save_fn,'mean_psd1','mean_psd2','psdMat1','psdMat2','lfp1','lfp2','suds_time_temp',...
            'suds_rating_temp', 'o1', 'o2','ol1','ol2');
        
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
                if ~exist([results_name,'figures\'])
                    mkdir([results_name,'figures\'])
                end
            saveas(fig,[results_name,'figures\',lfp_dir_all(i).name(1:(end-4)),'_',num2str(l),'_PSD.png'])
            close(fig);
            end            
    end
end
ax1.XLim(1) = 0;

ax1.XLim(2) = 70;
fig = gcf;

saveas(fig,[final_figure_path,'/sprint_symptom_figure.svg'])
saveas(fig,[final_figure_path,'/sprint_symtpom_figure.png'])
 
plot_results;