%%
C = table2cell(readtable([loaddir,'strivestudy_patient_logs20200921.csv']));

subject_email = ['bcmadbs005@gmail.com'];
type = 'Intensity of OCD';
idx = find(and(strcmp(C(:,1),subject_email),strcmp(C(:,4),type)));
intensity_unix = C(idx,3);
intensity = cell2mat(C(idx,8));

dates = datetime(cell2mat(intensity_unix),'ConvertFrom','posixtime','TimeZone','America/Chicago');
starttime= datetime(2020,9,20,2,0,0,'TimeZone','America/Chicago');

%% load all data streams
apple_watch_accel = csvread([loaddir,'aw_accel.csv']);
apple_watch_accel_times = apple_watch_accel(:,1);
aw_x = apple_watch_accel(:,2);
aw_y = apple_watch_accel(:,3);
aw_z = apple_watch_accel(:,4);

apple_watch_accel_dates = datetime(apple_watch_accel_times,'ConvertFrom','posixtime','TimeZone','America/Chicago');

%HR_times,hr_bpm
hr = csvread([loaddir,'hr.csv']);
hr_bpm = hr(:,2);
hr_dates = datetime(hr(:,1),'ConvertFrom','posixtime','TimeZone','America/Chicago');


% Acc_times,x, y, z
rcs_accel = csvread([loaddir,'rcs_accel.csv']);
rcs_accel_times = rcs_accel(:,1);
x = rcs_accel(:,2);
y = rcs_accel(:,3);
z = rcs_accel(:,4);
rcs_accel_dates = datetime(rcs_accel_times,'ConvertFrom','posixtime','TimeZone','America/Chicago');

% lfp
lfp_all = csvread([loaddir,'lfp.csv']);
lfp_ch1 = lfp_all(:,2);
lfp_ch2 = lfp_all(:,4);
lfp_dates = datetime(lfp_all(:,1),'ConvertFrom','posixtime','TimeZone','America/Chicago');


%% subtract date of start time and turn into seconds
HR_times = seconds(hr_dates-starttime);
aw_times = seconds(apple_watch_accel_dates-starttime);
int_dates = seconds(dates-starttime);
lfp_times{1} = seconds(lfp_dates-starttime);
Acc_times = seconds(rcs_accel_dates - starttime);

%%
num_subplots = 4;
timespan = [0,90];

c = [3,12,125;... %EKG
    31,120,180;... %BVP
    178,223,138;... % not used
    51,160,44;... % not used
    227,26,28;...%left
    124,10,2;...%right
    253,191,111;...%left
    255,127,0;...%right
    140,150,198;...%x
    140,107,177;...%y
    136,65,157;...%z
    255 91 165;...%
    255 187 218]/255;%

f = figure('Color','w');
f.Units = 'inches';
f.Position = [1,1,12,5.5];
f.PaperPosition = [1,1,12,5.5];
i = 1;
ax(i) = subplot(num_subplots,1,i);
plot(HR_times,hr_bpm,'Color',c(2,:),'LineWidth',1.2)
ylabel({'Apple Watch';'HR (bpm)'})
hold on
ax(i).XAxis.Visible = 'off';
ax(i).XAxis.Visible = 'off';
box off

i = 2;
ax(i) = subplot(num_subplots,1,i);
plot(aw_times,aw_x,'Color',c(9,:),'LineWidth',1.5)
hold on
plot(aw_times,aw_y,'Color',c(10,:),'LineWidth',1.5)
hold on
plot(aw_times,aw_z,'Color',c(11,:),'LineWidth',1.5)
legend({'x';'y';'z'})
ylabel({'Apple Watch';'Accel. (g)'})

box off
ax(i).XAxis.Visible = 'off'; 
   
i = 3;
ax(i) = subplot(num_subplots,1,i);
plot(Acc_times,x,'Color',c(9,:),'LineWidth',1.5)
hold on
plot(Acc_times,y,'Color',c(10,:),'LineWidth',1.5)
hold on
plot(Acc_times,z,'Color',c(11,:),'LineWidth',1.5)
legend({'x';'y';'z'})
ylabel({'RC+S';'Accel. (g)'})

box off
ax(i).XAxis.Visible = 'off';

i = 4;
fs_lfp = 250;
ax(i) = subplot(num_subplots,1,i);
lfp_filt = designfilt('lowpassfir','samplerate',fs_lfp,'passbandfrequency',100,'stopbandfrequency',125,...
    'stopbandattenuation',40,'passbandripple',0.1);
lfp_ch1 = filtfilt(lfp_filt,lfp_ch1);
lfp_ch2 = filtfilt(lfp_filt,lfp_ch2);
lfp_ch1 = lfp_ch1 - mean(lfp_ch1);
lfp_ch2 = lfp_ch2 - mean(lfp_ch2);
plot(lfp_times{1},lfp_ch1,'Color',c(7,:),'LineWidth',1.2)
hold on
plot(lfp_times{1},lfp_ch2,'Color',c(8,:),'LineWidth',1.2)
legend({'Left';'Right'})
ylabel('LFP (mV)')
ax(i).YLim = [-3e-4,3e-4];
xlabel('Seconds')

box off

linkaxes(ax,'x')
ax(i).XLim = timespan;
for j = 1
    axes(ax(j))
    scatter(53,ax(j).YLim(2),'*','MarkerFaceColor',([231,138,195])/255,'LineWidth',8)
end
for j = 1:(i-1)
ax(j).XTickLabel = [];
end
ax(2).Legend.String = {'x';'y';'z'};
ax(3).Legend.String = {'x';'y';'z'};
ax(4).Legend.String = {'Left';'Right'};
ax(1).FontSize = 12;
ax(2).FontSize = 12;
ax(3).FontSize = 12;
ax(4).FontSize = 12;

saveas(gcf,[savedir,'example-sprint-data.jpeg'])
saveas(gcf,[savedir,'example-sprint-data.fig'])