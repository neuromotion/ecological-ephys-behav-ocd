close all;
clear all;
load_dir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\Fig3\';
save_dir = 'C:\Users\Nicol\OneDrive\Documents\Results\Fig3\';

addpath(genpath(load_dir))
addpath(genpath(save_dir))

%% loading files

close all
load('aDBS007programming_plot_v2.mat');
data_au6 = load('au6_combined_ordinal.mat');
data_au12 = load('au12_combined_ordinal.mat');
load('processed_data.mat');
load('007_20200910_01_01_01_420-600_dynamic_3.mat')


%% parameters
t1=452;
t2=563; 

ft_size=12;
FR=25;
limit1 = 11463;

limit2 =ceil(FR*t2);%ending frame of the segment
len=limit2-limit1+1;%frame length of the segment

num_row = 10;
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
    248 24 148;...
    255 120 165;...%
    255 187 218]/255;%

%%  process data

EEG_ch_filtered = EEG_ch_filtered';
EKG_ch = max(EKG_ch)-EKG_ch-1;
pulse = pulse-1;
figure;
plot(EKG_ch)

for f = limit1
    video_frame = f/FR;
    fig = figure('Color','w','Renderer','painters','Position',[0,0,800,1200]);

    %% frame level sliding window left/right limits
    limit3=f-FR*5;
    limit4=f+FR*5-1;
    len2=limit4-limit3+1;
    x_len = linspace(limit3,limit4,len2);
    timespan=[limit3/FR,limit4/FR];
    

    %% 1st EKG
    ind_EEG_times_temp = find(and(EEG_times >= timespan(1), EEG_times <= timespan(2)));
    
    i = 5;
    ax_1 = subplot(num_row,num_col,5);
    set(ax_1,'ColorOrder',[c(2,:);c(1,:)])
    yyaxis left
    plot(EEG_times(ind_EEG_times_temp),pulse(ind_EEG_times_temp),'Color',c(2,:),'LineWidth',1.2)
    ax_1.YLim=[-2 1];
    %ax_1.YAxis(:).FontSize = ft_size-4;
    ylabel({'';'BVP';'(mV)'},'fontsize',ft_size-2)

    yyaxis right
    plot(EEG_times(ind_EEG_times_temp),EKG_ch(ind_EEG_times_temp),'Color',c(1,:),'LineWidth',1.2)
    ylabel({'ECG';'(mV)'},'fontsize',ft_size-2)
    ax_1.YLim=[-1 2];
    ax_1.XAxis.Visible = 'off';
    hold on 
    box off

    %% 2nd EEG
    i = 6:7;
    ax_2 = subplot(num_row,num_col,[6:7]);
    cmap = summer(num_EEG*2);
    for j = 1:64
    plot(EEG_times(ind_EEG_times_temp),EEG_ch_filtered{j}(ind_EEG_times_temp)+(j-1)*200,'Color',cmap(j,:),'LineWidth',.5)
    hold on
    end
    
    ax_2.XAxis.Visible = 'off';
    yticks([0,31000/5,63000/5])
    yticklabels({'64','32','1'})
    hold on 

    hold on 
    ax_2.YLim = [-500,63500/5];

    ax_2.YAxis.FontSize=ft_size-4; 
   
    ylabel({'EEG';'Channel #';'({\mu}V)'},'fontsize',ft_size-2)
    box off
    
   
    %% 3 DBS
    i = 8;
    ax_3 = subplot(num_row,num_col,8);
    ind_stim_params_temp = find(and(stim_params_times >= timespan(1), stim_params_times <= timespan(2)));
    plot(stim_params_times(ind_stim_params_temp),stim_amp(ind_stim_params_temp),'Color',c(5,:),'LineWidth',1.2)
    hold on
    plot(stim_params_times(ind_stim_params_temp),zeros(size(stim_params_times(ind_stim_params_temp))),'Color',c(6,:),'LineWidth',1.2)

    ax_3.XAxis.Visible = 'off';
    lgd = legend('Left','Right','fontsize',ft_size-4,'Location','northeast','NumColumns',1);
    lgd.Position(4) = lgd.Position(4)-.01;
    lgd.Position(2) = lgd.Position(2)+.02;
    legend('boxoff')
    
    ax_3.YLim=[0 5];
    
    yticklabels({'0','1','2','3','4','5'})
    
	yticks([0,1,2,3,4,5])
    ax_3.YAxis.FontSize=ft_size-4; 
    ylabel({'DBS'; 'Amplitude';'(mA)'},'fontsize',ft_size-2)
    hold on 
    box off
%% 4 LFP
    i = 9;
    ax_4 = subplot(num_row,num_col,9);
    %colororder(c(7:8,:))
    ind_lfp_times_temp = find(and(lfp_times >= timespan(1), lfp_times <= timespan(2)));
    yyaxis left 
    plot(lfp_times(ind_lfp_times_temp),lfp_ch1(ind_lfp_times_temp),'Color',c(7,:),'LineWidth',1.2)
    ax_4.YLim=[-0.2 1];

    set(ax_4,{'ycolor'},{c(7,:)});
    ylabel({'';'LFP'; '(mV)'},'fontsize',ft_size-2,'Color','k')

    hold on
    yyaxis right
    plot(lfp_times(ind_lfp_times_temp),lfp_ch2(ind_lfp_times_temp),'Color',c(8,:),'LineWidth',1.2)

    ax_4.XAxis.Visible = 'off';
    ax_4.YLim=[-0.1 .1];
    
    set(ax_4,{'ycolor'},{c(8,:)});
    ax_4.YAxis(1).FontSize=ft_size-4; 
    ax_4.YAxis(2).FontSize=ft_size-4; 

    hold on 
    box off
    lgd = legend({'Left';'Right'},'fontsize',ft_size-4,'Location','northeast','NumColumns',1);
    legend('boxoff')
    lgd.Position(4) = lgd.Position(4)-.01;
    lgd.Position(2) = lgd.Position(2)+.02;

%% 5 Acc
    i = 10;
    ax_5 = subplot(num_row,num_col,10);
    ind_Acc_times_temp = find(and(Acc_times >= timespan(1), Acc_times <= timespan(2)));

    plot(Acc_times(ind_Acc_times_temp),x(ind_Acc_times_temp),'Color',c(9,:),'LineWidth',1.2)
    hold on
    plot(Acc_times(ind_Acc_times_temp),y(ind_Acc_times_temp),'Color',c(10,:),'LineWidth',1.2)
    hold on
    plot(Acc_times(ind_Acc_times_temp),z(ind_Acc_times_temp),'Color',c(11,:),'LineWidth',1.2)

    lgd = legend({'x';'y';'z'},'fontsize',ft_size-4,'Location','northeast','NumColumns',1);
    lgd.Position(4) = lgd.Position(4)-.01;
    lgd.Position(2) = lgd.Position(2)+.03;
    lgd.Position(1) = lgd.Position(1)-.01;

    legend('boxoff')
    ax_5.YAxis.FontSize=ft_size-4; 

    ax_5.YLim=[-10 35];
    ax_5.XAxis.Visible = 'on';
    ylabel({'RC+S'; 'Accel.'; '(g)'},'fontsize',ft_size-4)
    xlabel('Seconds','fontsize',ft_size-2)
    ax_5.XTickLabel = {'3';'4';'5';'6';'7';'8';'9';'10';'11';'12'};
    hold on
    box off
%% 6 AU
    i = 3;

    fps= 25;
    length_int = length(data_au6.est_int);
    int_times = (1/fps):(1/fps):(length_int/fps);
    
    int_times_temp = find(and(int_times >= timespan(1), int_times <= timespan(2)));

    ax_6 = subplot(num_row,num_col,3);
    PA=(data_au6.est_int+data_au12.est_int)/2;
    plot(int_times(int_times_temp),PA(int_times_temp),'Color',c(12,:),'LineWidth',1.2)

    
    ax_6.YLim = [0 5];
    
    yticklabels({'0','1','2','3','4','5'})
    
	yticks([0,1,2,3,4,5])
    ax_6.YAxis.FontSize=ft_size-4; 
    ylabel({'Positive'; 'Affect';'(intensity)'},'fontsize',ft_size-2)
    ax_6.XAxis.Visible = 'off';
    hold on
    box off
    %% 7 head
    i = 4;


    length_head = length(vel_per_sec);
    head_times = (1/fps):(1/fps):(length_head/fps);
    head_times_temp = find(and(head_times >= timespan(1), head_times <= timespan(2)));
    ax_7 = subplot(num_row,num_col,4);
    plot(head_times(head_times_temp),vel_per_sec(head_times_temp,1),'Color',c(13,:),'LineWidth',1.2)
    hold on
    plot(head_times(head_times_temp),vel_per_sec(head_times_temp,2),'Color',c(14,:),'LineWidth',1.2)

    ax_7.YLim=[-50,50];
    
    ax_7.YAxis.FontSize=ft_size-4;   
    ax_7.XAxis.Visible = 'off';
    ylabel({'Head';'Velcoity';['(',char(176), '/Fr)']},'fontsize',ft_size-2)
    lgd = legend({'pitch';'yaw'},'fontsize',ft_size-4,'Location','northeast','NumColumns',1);
    lgd.Position(4) = lgd.Position(4)+.02;
    lgd.Position(2) = lgd.Position(2)+.01;
    legend('boxoff')


    hold on
    box off

    %% link right panel
     linkaxes([ax_1,ax_2,ax_3,ax_4,ax_5],'x')
     ax_5.XLim = timespan;
    ax_5.YAxis.FontSize=ft_size-2;
    ax_1.XTickLabel = [];
    ax_2.XTickLabel = [];
    ax_3.XTickLabel = [];
    ax_4.XTickLabel = [];
    %% link left panel
    linkaxes([ax_6,ax_7],'x')
    ax_7.XLim = timespan;
    norm_time1 = timespan(1) - (limit1/FR) + 5 + 2;
    norm_time2 = timespan(1) - (limit1/FR) + 15;
    helper = round(cellfun(@str2num,ax_7.XTickLabel)-limit1/FR+(1/FR));
    helperstr = cellstr(num2str(helper));
    ax_7.XTickLabel = helperstr;
    ax_5.XTickLabel = helperstr;
    
    ax_6.XTickLabel = [];

    % smile frame marker
    axes(ax_1)
    plot([video_frame,video_frame],ax_1.YLim,'-k')
    axes(ax_2)
    plot([video_frame,video_frame],ax_2.YLim,'-k')
    axes(ax_3)
    plot([video_frame,video_frame],ax_3.YLim,'-k')
    axes(ax_4)
    plot([video_frame,video_frame],ax_4.YLim,'-k')
    axes(ax_5)
    plot([video_frame,video_frame],ax_5.YLim,'-k')
    axes(ax_6)
    plot([video_frame,video_frame],ax_6.YLim,'-k')
    axes(ax_7)
    plot([video_frame,video_frame],ax_7.YLim,'-k')
    
    % first frame marker
    video_frame = 11363/FR;
    axes(ax_1)
    plot([video_frame,video_frame],ax_1.YLim,'-k')
    axes(ax_2)
    plot([video_frame,video_frame],ax_2.YLim,'-k')
    axes(ax_3)
    plot([video_frame,video_frame],ax_3.YLim,'-k')
    axes(ax_4)
    plot([video_frame,video_frame],ax_4.YLim,'-k')
    axes(ax_5)
    plot([video_frame,video_frame],ax_5.YLim,'-k')
    axes(ax_6)
    plot([video_frame,video_frame],ax_6.YLim,'-k')
    axes(ax_7)
    plot([video_frame,video_frame],ax_7.YLim,'-k')
        
    % last frame marker  
    video_frame = 11530/FR;
    axes(ax_1)
    plot([video_frame,video_frame],ax_1.YLim,'-k')
    axes(ax_2)
    plot([video_frame,video_frame],ax_2.YLim,'-k')
    axes(ax_3)
    plot([video_frame,video_frame],ax_3.YLim,'-k')
    axes(ax_4)
    plot([video_frame,video_frame],ax_4.YLim,'-k')
    axes(ax_5)
    plot([video_frame,video_frame],ax_5.YLim,'-k')
    axes(ax_6)
    plot([video_frame,video_frame],ax_6.YLim,'-k')
    axes(ax_7)
    plot([video_frame,video_frame],ax_7.YLim,'-k')

    ax_5.Legend.String = {'x';'y';'z'};
    ax_3.Legend.String = {'Left';'Right'};
    ax_4.Legend.String = {'Left';'Right'};
    ax_7.Legend.String = {'pitch';'yaw'};

  
    %% image

    set(gca,'YTick',[]);
    set(gca,'XTick',[]);
    set(gca, 'box', 'off');
    

    %% save
    ax_5.XTickLabel = {'3';'4';'5';'6';'7';'8';'9';'10';'11';'12'};
    ax_5.YAxis.FontSize=ft_size-4; 
    
    img_name=[save_dir,'007_programming_full-page-single-col.png'];
    saveas(fig,img_name);
    
    img_name=[save_dir,'007_programming_full-page-single-col.svg'];
    saveas(fig,img_name);

end