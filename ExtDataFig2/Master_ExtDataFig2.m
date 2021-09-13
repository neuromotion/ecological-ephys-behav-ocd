close all;
clear all;
save_dir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig2\';
load_dir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig2\';
%%
subjects={'aDBS004','aDBS005','aDBS007'};
load([load_dir,'pImps.mat'])
for i= 1:3
    subject = subjects{i};
    temp_imp = pImps{i};
    dates = NaT(length(temp_imp),1);
    stimChans = cell(length(temp_imp),1);
    td1 = cell(length(temp_imp),1);
    td2 = cell(length(temp_imp),1);
    Imp_all = NaN(length(temp_imp),8);
    
    td11 = NaN(length(temp_imp),1);
    td12 = NaN(length(temp_imp),1);
    td21 = NaN(length(temp_imp),1);
    td22 = NaN(length(temp_imp),1);
    
    stimChan1 = NaN(length(temp_imp),1);
    stimChan2 = NaN(length(temp_imp),1);
    
    for j = 1:length(temp_imp)
        temp_imp1 = temp_imp{j};
        dates(j) = datetime(temp_imp1.date);
        stimChans{j} = [temp_imp1.stimChans{1},temp_imp1.stimChans{2}];
        stimChans{j}
        if ~isempty(stimChans{j})
            stimChan1(j) = stimChans{j}(1);
        end
        if ~isempty(stimChans{j})
            if length(stimChans{j})==2
                stimChan2(j) = stimChans{j}(2);
            end
        end
        
        td1{j} = temp_imp1.td1;
        td2{j} = temp_imp1.td2;
        td11(j) = temp_imp1.td1(1);
        td12(j) = temp_imp1.td1(2);
        td21(j) = temp_imp1.td2(1);
        td22(j) = temp_imp1.td2(2);
        
        Imp_all(j,:) = [temp_imp1.senseImpedance,temp_imp1.stimImpedance];
    end
    
    if strcmp(subject,'aDBS005')
        start_date = datetime(2019,12,5);
        impedance_hardcoded;
    elseif strcmp(subject,'aDBS007')
        start_date = datetime(2020,9,10);
        dates(1) = [];
        Imp_all(1,:) = [];
        td11(1) = [];
        td12(1) = [];
        td21(1) = [];
        td22(1) = [];
        stimChan1(1) = [];
        stimChan2(1) = [];
        
        Imp_all(1,8) = 1463;
        Imp_all(2,8) = 1468;
        Imp_all(4,8) = 765;
    elseif strcmp(subject,'aDBS004')
        start_date = datetime(2020,2,18);
    end
    dates_norm = days(dates - start_date);
    %%
    cmap = [31,120,180;178,223,138;51,160,44;251,154,153;251,154,153]/255;
    f = figure;
    f.Units = 'inches';
    f.Position = [1,1,8,4];    
    h(1) = subplot(1,2,1)
    plot(dates_norm,Imp_all(:,1),'-o','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:))
    hold on
    plot(dates_norm,Imp_all(:,3),'-o','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:))
    hold on
    plot(dates_norm,Imp_all(:,4),'-o','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:))
    hold on
    plot(dates_norm,Imp_all(:,7),'-o','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:))
    title('Left Hemisphere')
    legend({'sense contact 1 to sense contact 2';'sense contact 1 to case';'sense contact 2 to case';'stimulation contact'},'Location','southoutside');
    ylabel('Impedance (\Omega)')
    xlabel('Days since DBS ON')

    h(2) = subplot(1,2,2)
    plot(dates_norm,Imp_all(:,2),'-o','Color',cmap(1,:),'MarkerFaceColor',cmap(1,:),'MarkerEdgeColor',cmap(1,:))
    hold on
    plot(dates_norm,Imp_all(:,5),'-o','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:),'MarkerEdgeColor',cmap(2,:))
    hold on
    plot(dates_norm,Imp_all(:,6),'-o','Color',cmap(3,:),'MarkerFaceColor',cmap(3,:),'MarkerEdgeColor',cmap(3,:))
    hold on
    plot(dates_norm,Imp_all(:,8),'-o','Color',cmap(4,:),'MarkerFaceColor',cmap(4,:),'MarkerEdgeColor',cmap(4,:))    
    title('Right Hemisphere')
    legend({'sense contact 1 to sense contact 2';'sense contact 1 to case';'sense contact 2 to case';'stimulation contact'},'Location','southoutside');
    xlabel('Days since DBS ON')

    linkaxes(h,'xy')
    
    saveas(gcf,[save_dir,subject,'_impedance_suppfigure.svg'])
    saveas(gcf,[save_dir,subject,'_impedance_suppfigure.png'])
    
    disp(subject)
    min_stim = min(min(Imp_all(:,7:8)));
    min_sense = min(min(Imp_all(:,3:6)));
    max_stim = max(max(Imp_all(:,7:8)));
    max_sense = max(max(Imp_all(:,3:6)));
    [min_stim max_stim]
    [min_sense max_sense]
    max(dates_norm)
    %%
%     legend({'Bipolar channel 1, contact 1 to bipolar channel 1, contact 2';...
%         'Bipolar channel 2, contact 1 to bipolar channel 2, contact 2';...
%         'Bipolar channel 1, contact 1 to Case';...
%         'Bipolar channel 1, contact 2 to Case';...
%         'Bipolar channel 2, contact 1 to Case';...
%         'Bipolar channel 2, contact 2 to Case';...
%         'Stim channel 1 to Case';...
%         'Stim channel 2 to Case';...
%         },'Location','southoutside');
    
    figure;
    subplot(1,2,1)
    plot(dates_norm,td11,'-o');
    hold on
    plot(dates_norm,td12,'-o');
    hold on
    plot(dates_norm,stimChan1,'-o');
    title('Channel 1')
    legend({'sense contact 1';'sense contact 2';'stim contact'})
    
    subplot(1,2,2)
    plot(dates_norm,td21,'-o');
    hold on
    plot(dates_norm,td22,'-o');
    hold on
    plot(dates_norm,stimChan2,'-o');
    title('Channel 2')
    legend({'sense contact 1';'sense contact 2';'stim contact'})

end