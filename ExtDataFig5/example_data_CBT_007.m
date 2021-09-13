close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig5\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig5\';

%% load all data streams

% Acc_times,x, y, z
rcs_accel = csvread([loaddir,'007_accel.csv']);
rcs_accel_times = rcs_accel(:,1);
x = rcs_accel(:,2);
y = rcs_accel(:,3);
z = rcs_accel(:,4);
x = (x - mean(x))/std(x);
y = (y - mean(y))/std(y);
z = (z - mean(z))/std(z);
rcs_accel_dates = datetime(rcs_accel_times,'ConvertFrom','posixtime','TimeZone','America/Chicago');

% lfp_times{1},lfp_ch1, lfp_ch2
lfp_all = csvread([loaddir,'007_lfp.csv']);
lfp_ch1 = lfp_all(:,2);
lfp_ch2 = lfp_all(:,4);
lfp_dates = datetime(lfp_all(:,1),'ConvertFrom','posixtime','TimeZone','America/Chicago');


%% subtract date of start time and turn into seconds
starttime = datetime(2021,5,21,15,3,54,0,'TimeZone','America/Chicago');
lfp_times = seconds(lfp_dates-starttime);
Acc_times = seconds(rcs_accel_dates - starttime);

%% parameters

ft_size=10;
FR=25;
num_row = 8;
num_col =1;

%% colors 
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

%%  process data
fs_lfp = 250;
lfp_filt = designfilt('lowpassfir','samplerate',fs_lfp,'passbandfrequency',100,'stopbandfrequency',125,...
    'stopbandattenuation',40,'passbandripple',0.1);
lfp_ch1 = filtfilt(lfp_filt,lfp_ch1);
lfp_ch2 = filtfilt(lfp_filt,lfp_ch2);

lfp_ch1 = lfp_ch1-mean(lfp_ch1);
lfp_ch2 = lfp_ch2-mean(lfp_ch2);

fig = figure('Color','w','Renderer','painters','Position',[0,0,800,700]);
timespan = seconds([datetime(2021,5,21,15,27,0,'TimeZone','America/Chicago'),datetime(2021,5,21,15,27,10,'TimeZone','America/Chicago')]-starttime);
      
i = 7;
ax9 = subplot(num_row,1,i);

ind_acc_times_temp = find(and(Acc_times>= timespan(1), Acc_times <= timespan(2)));
Acc_times_start = Acc_times(ind_acc_times_temp(1));
Acc_times_end = Acc_times(ind_acc_times_temp(end));
Acc_times_plot = linspace(Acc_times_start,Acc_times_end,length(ind_acc_times_temp));
plot(Acc_times_plot,x(ind_acc_times_temp),'Color',c(9,:),'LineWidth',1.5)
hold on
plot(Acc_times_plot,y(ind_acc_times_temp),'Color',c(10,:),'LineWidth',1.5)
hold on
plot(Acc_times_plot,z(ind_acc_times_temp),'Color',c(11,:),'LineWidth',1.5)
hold on
video_frame = 1396;
plot([video_frame,video_frame],ax9.YLim,'-k')

lgd = legend({'x';'y';'z'},'fontsize',ft_size-2,'Location','northeast','NumColumns',3);
lgd.Position(4) = lgd.Position(4)-.01;
lgd.Position(2) = lgd.Position(2)+.04;
legend('boxoff')

ax9.YAxis.FontSize=ft_size-2; 
ylabel({'RC+S';'Accel. (g)'},'fontsize',ft_size)

box off
hold on

ax9.XAxis.Visible = 'off';


%% 4 LFP
i = 8;
ax10 = subplot(num_row,num_col,i);
ind_lfp_times_temp = find(and(lfp_times >= timespan(1), lfp_times <= timespan(2)));
lfp_times_start = lfp_times(ind_lfp_times_temp(1));
lfp_times_end = lfp_times(ind_lfp_times_temp(end));
lfp_times_plot = linspace(lfp_times_start,lfp_times_end,length(ind_lfp_times_temp));
plot(lfp_times_plot,lfp_ch1(ind_lfp_times_temp),'Color',c(7,:),'LineWidth',1.2)
hold on
plot(lfp_times_plot,lfp_ch2(ind_lfp_times_temp),'Color',c(8,:),'LineWidth',1.2)
ax10.YLim=[-5e-5 5e-5];
ax10.YAxis.FontSize=ft_size-2; 

hold on 
plot([video_frame,video_frame],ax10.YLim,'-k')

box off
lgd = legend({'Left';'Right'},'fontsize',ft_size-2,'Location','northeast','NumColumns',2);
lgd.Position(4) = lgd.Position(4)-.01;
lgd.Position(2) = lgd.Position(2)+.04;
legend('boxoff')

xlabel('Seconds','fontsize',ft_size)

ax10.YAxis.FontSize=ft_size-2; 
ylabel('LFP (mV)','fontsize',ft_size)

hold on
box off

%% link right panel
linkaxes([ax9,ax10],'x')
ax10.XLim = timespan;

%% link left panel
helper = [0:10]';
helperstr = cellstr(num2str(helper));
ax10.XTickLabel = helperstr;
ax10.Legend.String = {'Left';'Right'};

%% save
img_name=[savedir,'CBT_screenshot007.png'];
saveas(fig,img_name);
img_name=[savedir,'CBT_screenshot007.svg'];
saveas(fig,img_name);

