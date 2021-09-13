close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig3\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig3\';
addpath(genpath(loaddir))
addpath(genpath(savedir))
%%
subject_all = {'aDBS004','aDBS005','aDBS007'};
f = figure;
f.Units = 'inches';
f.Position = [1,1,12,9];

for i = 1:length(subject_all)
    clearvars datastruct
    subject = subject_all{i};
    suds_all = readmatrix([loaddir,subject,'_suds_all.xlsx']);

    c = [175,222,105;141,211,199;251,128,114]/255;

    % organize into a struct labeled with ybocs scores
    if strcmp(subject,'aDBS007')
        names = {'a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m';'n'};
    else
        names = {'a';'b';'c';'d';'e';'f';'g';'h';'i';'j';'k';'l';'m'};
    end
        suds_all_corrected = nan(size(suds_all));
        for j = 1:length(names)
            temp_suds = suds_all(j,:);
            temp = find(or(isnan(temp_suds),temp_suds==-1));
            if ~isempty(temp)
                temp_suds(temp) = [];
            end
            vals = temp_suds;
            datastruct.(names{j}) = vals;
            suds_all_corrected(j,1:length(vals)) = vals;
        end
        c = [175,222,105;141,211,199;251,128,114]/255;

        ybocs_str = strsplit(num2str([1:length(names)]));
        subplot(3,1,i)
        violinplot(datastruct,ybocs_str,'ViolinColor',c(i,:))
        ax = gca;
        ax.FontSize = 10;
        hold on

        for j = 1:length(1:length(names))
            scatter(ax,repmat(j,size(suds_all_corrected,2),1),suds_all_corrected(j,:),'filled','MarkerFaceColor',c(i,:))
            hold on
        end
        ax.XTickLabels = ybocs_str;
        ax.YLim = [0,10];
        if i==1
            sub = 'P3';
        elseif i==2
            sub = 'P4';
        elseif i==3
            sub = 'P5';
        end
            ylabel([sub, ': SUDs'],'FontSize',12)
            
        if i ==3
        xlabel('ERP Session Number','FontSize',12)
        end
end

saveas(gcf,[savedir,'ERP_sessions_supp_figure.svg'])
saveas(gcf,[savedir,'ERP_sessions_supp_figure.png'])