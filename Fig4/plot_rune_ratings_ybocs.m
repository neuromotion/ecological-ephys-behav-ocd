%%
c = [175,222,105;141,211,199;251,128,114]/255;

subject_all = {'aDBS004';'aDBS005';'aDBS007'};
    f = figure
    f.Units = 'inches';
    f.Position = [1,1,12,6];
    f.PaperPosition = [1,1,12,6];
for i = 1:length(subject_all)
    subject = subject_all{i};
    subject_email = subject;

    type = 'Intensity of OCD';
    % get dates of programming visits
    load([loaddir,subject,'_clinical_scores_summary.mat'])
    dates_norm = dates_norm{1};
    visit_dates = dates{1};
    ybocs = scores{2};
    ybocs2 = scores{1};
    
    C = table2cell(readtable([loaddir,'strivestudy_patient_logs20210624_combined.csv']));

    idx = find(and(strcmp(C(:,1),subject_email),strcmp(C(:,3),type)));
    intensity_unix = C(idx,2);
    intensity = cell2mat(C(idx,4));
    
    % find visit dates out of range
    if strcmp(subject,'aDBS005')
        del = find(visit_dates < datetime('2020-03-04'));
        xval = 3.4;
    elseif strcmp(subject,'aDBS004')
        del = find(visit_dates < datetime('2020-02-01'));
        xval = 2.8;
    elseif strcmp(subject,'aDBS007')
        del = find(visit_dates<datetime('2020-08-01'));
        xval = 1.9;
    else
        del = 0;
    end
    
    dates = datetime(cell2mat(intensity_unix),'ConvertFrom','posixtime','TimeZone','America/Chicago');
    dates_normi = zeros(size(dates));
    fp_date = datetime(fp_date,'TimeZone','America/Chicago');
    for j = 1:length(dates)
        [W,D]=split(between(fp_date,dates(j),{'weeks','days'}),{'weeks','days'});
        val = W+(D/7);
        dates_normi(j,1)=val;
    end

    %%
    del = [];
    mean_intensity = zeros(length(visit_dates),1);
    std_intensity = zeros(length(visit_dates),1);
    ybocs_matched_to_mean_intensity = zeros(length(visit_dates),1);
    for j = 2:(length(visit_dates)+1)
        helper = find(and(dates_normi<dates_norm(j-1),dates_normi>(dates_norm(j-1)-7/7)));
        if isempty(helper)
            del = [del;(j-1)];
        else
            ybocs_matched_to_mean_intensity(j-1) = dates_norm(j-1);            
            temp_mean = median(intensity(helper));
            temp_std = std(intensity(helper));
            mean_intensity(j-1) = temp_mean;
            std_intensity(j-1) = temp_std;
        end
    end
    ybocs_matched_to_mean_intensity(del) = [];
    mean_intensity(del) = [];
    std_intensity(del) = [];
    %%
    ax(i) = subplot(3,1,i);
    ax2 = gca;
    colororder({'k','k'})

    yyaxis(ax2,'left')
    p(1) = scatter(dates_normi,intensity,30,'filled','MarkerFaceColor',c(i,:));
    hold on
    ax2.YLim = [-.1,10.1];

    x = [ax2.XLim(1),ax2.XLim(1),ax2.XLim(2),ax2.XLim(2)];
    y = [ax2.YLim(2)-4.2,ax2.YLim(2),ax2.YLim(2),ax2.YLim(2)-4.2];
    ax2.FontSize = 13;
    if i==2
        ylabel({'Self-Reported Intensity of OCD Symptoms'},'FontSize',14)
    elseif i==3
    xlabel('Weeks since DBS ON','FontSize',14)
    end

    for j = 1:length(visit_dates)
        if strcmp(subject,'aDBS005')
            p(6) = plot([dates_norm(j),dates_norm(j)],ax2.YLim,'k','LineStyle','--');
            hold on
        elseif strcmp(subject,'aDBS007')
             p(6) = plot([dates_norm(j),dates_norm(j)],ax2.YLim,'k','LineStyle','--');
            hold on
        elseif and(strcmp(subject,'aDBS004'),j>1)
             p(6) = plot([dates_norm(j),dates_norm(j)],ax2.YLim,'k','LineStyle','--');
             hold on
        end
    end
    helper = ax2.XLim;
    ax2.YLim(1) = ax2.YLim(1)+.1;
    ax2.YLim(2) = ax2.YLim(2)-.1;
    ax2.YTick = [0,2,4,6,8,10];
    ax2.YTickLabel = cellstr(num2str(ax2.YTick'));
    yyaxis(ax2,'right')
    hold on
    if strcmp(subject,'aDBS004')
        dates_norm(1) = [];
        ybocs2(1) = [];
    end
    p(5) = plot(dates_norm,ybocs2,'-s','Color',[.2,.2,.2],'MarkerFaceColor',[.9,.9,.9]);
    if strcmp(subject,'aDBS005')
        max_helper1 = max(dates_norm);
        max_helper2 = max(dates_normi);
    end

    ax2.FontSize = 13;

    if i==2
    ylabel({'Y-BOCS II Score'},'FontSize',16)
    end
    ax2.XLim = helper;

    min(std_intensity)
    max(std_intensity)
    fn = [savedir,subject,'-rune-ratings.mat'];
    intensity_dates= dates_normi;
    save(fn,'intensity_dates','intensity')
end
linkaxes([ax(1),ax(2),ax(3)],'xy')
val = max([max_helper1,max_helper2]);
ax(2).XLim(2) = val+1;
saveas(gcf,[savedir,'ybocs_rune_over_time.svg'])
saveas(gcf,[savedir,'ybocs_rune_over_time.jpg'])
