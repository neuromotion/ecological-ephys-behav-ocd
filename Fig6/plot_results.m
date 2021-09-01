%% Load all results
files= dir([results_path,results_name]);
files(1:2) = [];

mean_psd1_all = zeros(length(files)-1,4096);
mean_psd2_all = zeros(length(files)-1,4096);
intensity_all = zeros(length(files)-1,1);
times_all = NaT([length(files)-1,1],'TimeZone','America/Chicago');
del = [];
for i = 1:(length(files)-1)
    if ~isempty(strfind(files(i).name,'Session'))
    load([results_path,results_name,files(i).name])
    mean_psd1_all(i,:) = mean_psd1;
    mean_psd2_all(i,:) = mean_psd2;
    intensity_all(i) = suds_rating_temp;
    times_all(i) = suds_time_temp;
    else
        del = [del;i];
    end
end
mean_psd1_all(del,:) = [];
mean_psd2_all(del,:) = [];
intensity_all(del) = [];
times_all(del) = [];
%% gather average power per band
bands = [4 8; 8 15; 15 30; 30 55; 55 80];

avg_pow_per_band1 = nan(size(mean_psd1_all,1),length(bands));
avg_pow_per_band2 = nan(size(mean_psd2_all,1),length(bands));
            
for i = 1:size(mean_psd1_all,1)
    pow_temp = mean_psd1_all(i,:);
    if ~isempty(pow_temp)
        for j = 1:length(bands)            
            band_bounds = bands(j,:);
            freq_inds = and(f1>band_bounds(1),f1<band_bounds(2));
            avg_pow_per_band1(i,j) = mean(pow_temp(:,freq_inds));
        end
    end
    pow_temp = mean_psd2_all(i,:);
    if ~isempty(pow_temp)
        for j = 1:length(bands)            
            band_bounds = bands(j,:);
            freq_inds = and(f1>band_bounds(1),f1<band_bounds(2));
            avg_pow_per_band2(i,j) = mean(pow_temp(:,freq_inds));
        end
    end
end

%% normalized by average power in spectrum from 4-80 hz at each timepoint
totalPower1=mean(mean_psd1_all(:,f1>4&f1<80),2);
totalPower2=mean(mean_psd2_all(:,f1>4&f1<80),2);
normpsd1=10*log10(mean_psd1_all./repmat(totalPower1,1,length(f)));
normpsd2=10*log10(mean_psd2_all./repmat(totalPower2,1,length(f)));


%% Delta power

c1 =   [253,191,111]/255;...%left
c2 =    [255,127,0]/255;...%right

f = figure;
f.Units = 'inches';
f.Position = [1,1,12,6];
ax1 = gca;

hold on;

[r1,p1]=corrcoef(intensity_all,mean(normpsd1(:,f1<4&f1>0),2));
[r2,p2]=corrcoef(intensity_all,mean(normpsd2(:,f1<4&f1>0),2));
subplot(2,5,1)
scatter(intensity_all,mean(normpsd1(:,f1<4&f1>0),2),'o','MarkerFaceColor',c1,'MarkerEdgeColor',c1,'MarkerFaceAlpha',.5)
h1=lsline;
h1.LineWidth = 1.5;
h1.Color = 'k';
ax1 = gca;
ax1.FontSize = 10;
ylabel({'Left LFP';'Normalized Power (dB)'},'FontSize',12)
%xlabel({'Self-Reported Intensity';'of OCD Symptoms'});%,'FontSize',13)
title({'Delta (0-4) Hz';['Left R=',num2str(r1(2))]},'FontSize',12);%'; p=',num2str(p1(2))]})

subplot(2,5,6)


scatter(intensity_all,mean(normpsd2(:,f1<4&f1>0),2),'o','MarkerFaceColor',c2,'MarkerEdgeColor',c2,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
ylabel({'Right LFP';'Normalized Power (dB)'},'FontSize',12)
title({'Delta (0-4) Hz';['Left R=',num2str(r2(2))]},'FontSize',12);%'; p=',num2str(p1(2))]})
h1=lsline;
h1.LineWidth = 1.5;
h1.Color = 'k';%ylabel('Normalized Delta Power (dB)')
xlabel({'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',12);%,'FontSize',13)

ax1 = gca;

%% Theta power
f_bool = and(f1>4,f1<8);
[r1,p1]=corrcoef(intensity_all,mean(normpsd1(:,f_bool),2));
[r2,p2]=corrcoef(intensity_all,mean(normpsd2(:,f_bool),2));

subplot(2,5,2)
scatter(intensity_all,mean(normpsd1(:,f_bool),2),'o','MarkerFaceColor',c1,'MarkerEdgeColor',c1,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
title({'Theta (4-8) Hz';['Left R=',num2str(r1(2))]},'FontSize',12);%'; p=',num2str(p1(2))]})

subplot(2,5,7)
scatter(intensity_all,mean(normpsd2(:,f_bool),2),'o','MarkerFaceColor',c2,'MarkerEdgeColor',c2,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
xlabel({'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',12)
title({'Theta (4-8) Hz';['Left R=',num2str(r2(2))]},'FontSize',12);%'; p=',num2str(p1(2))]})

%% Alpha power
f_bool = and(f1>8,f1<15);
[r1,p1]=corrcoef(intensity_all,mean(normpsd1(:,f_bool),2));
[r2,p2]=corrcoef(intensity_all,mean(normpsd2(:,f_bool),2));
subplot(2,5,3)
scatter(intensity_all,mean(normpsd1(:,f_bool),2),'o','MarkerFaceColor',c1,'MarkerEdgeColor',c1,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
title({'Alpha (8-15 Hz)';['R=',num2str(r1(2))]},'FontSize',12);%,'; p=',num2str(p1(2))]})

subplot(2,5,8)
scatter(intensity_all,mean(normpsd2(:,f_bool),2),'o','MarkerFaceColor',c2,'MarkerEdgeColor',c2,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
xlabel({'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',12)
title({'Alpha (8-15 Hz)';['R=',num2str(r2(2))]},'FontSize',12);%,'; p=',num2str(p2(2))]})

%% Beta power
f_bool = and(f1>15,f1<30);
[r1,p1]=corrcoef(intensity_all,mean(normpsd1(:,f_bool),2));
[r2,p2]=corrcoef(intensity_all,mean(normpsd2(:,f_bool),2));
subplot(2,5,4)
scatter(intensity_all,mean(normpsd1(:,f_bool),2),'o','MarkerFaceColor',c1,'MarkerEdgeColor',c1,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
title({'Beta (15-30 Hz)';['R=',num2str(r1(2))]},'FontSize',12);%,'; p=',num2str(p1(2))]})

subplot(2,5,9)
scatter(intensity_all,mean(normpsd2(:,f_bool),2),'o','MarkerFaceColor',c2,'MarkerEdgeColor',c2,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
xlabel({'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',12)
title({'Beta (15-30 Hz)';['R=',num2str(r2(2))]},'FontSize',12);%,'; p=',num2str(p2(2))]})

%% Gamma power
f_bool = and(f1>30,f1<55);
[r1,p1]=corrcoef(intensity_all,mean(normpsd1(:,f_bool),2));
[r2,p2]=corrcoef(intensity_all,mean(normpsd2(:,f_bool),2));
subplot(2,5,5)
scatter(intensity_all,mean(normpsd1(:,f_bool),2),'o','MarkerFaceColor',c1,'MarkerEdgeColor',c1,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
title({'Gamma (30-55 Hz)';['R=',num2str(r1(2))]},'FontSize',12);%,'; p=',num2str(p1(2))]})

subplot(2,5,10)
scatter(intensity_all,mean(normpsd2(:,f_bool),2),'o','MarkerFaceColor',c2,'MarkerEdgeColor',c2,'MarkerFaceAlpha',.5)
ax1 = gca;
ax1.FontSize = 10;
h1=lsline; h1.LineWidth = 1.5; h1.Color = 'k';
xlabel({'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',12)
title({'Gamma (30-55 Hz)';['R=',num2str(r2(2))]},'FontSize',12);%,'; p=',num2str(p2(2))]})

saveas(gcf,[results_path,results_name,'/power_suds_suppfigure.svg'])
saveas(gcf,[results_path,results_name,'/power_suds_suppfigure.png'])
saveas(gcf,[figure_path,'power_v_suds','/',subject_id,'_',date_str_i,'_power_suds_suppfigure.png'])
