close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig5\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig5\';
%%
c = [31,120,180]/255;

fig = figure('Color','w','Renderer','painters','Position',[0,0,600,200]);
date = '2021-05-21';

% get dates of OCD intensity readings
rune_data = readtable([loaddir,date,'_CBT_SUDS_','aDBS007','.xlsx']);
intensity_unix =  double(table2array(rune_data(:,1)));
intensity_rows = 1:height(rune_data); 

for i = 1:length(intensity_rows)
    rating_temp = rune_data.rating(i);
    SUDS.ratings(i) = rating_temp;
    time_temp = datetime(intensity_unix(i),'ConvertFrom','posixTime','TimeZone','America/Chicago','Format','dd-MMM-yyyy HH:mm:ss.SSS');
    SUDS.times(i) = time_temp;
end

suds_times = SUDS.times;

starttime = suds_times(1);
suds_time_s = minutes(suds_times - starttime);
ft_size=14;

frame_time = minutes(datetime(2021,5,21,10,27,5,'TimeZone','America/Chicago')-starttime);

%yyaxis left
ax1 = gca;
plot(suds_time_s,SUDS.ratings,'k-o','LineWidth',1.2,'MarkerFaceColor','k')
set(ax1,{'ycolor'},{'k'});
ylabel('SUDs','fontsize',ft_size)
xlabel('Minutes','fontsize',ft_size)
ax1.XLim = [0,23];

ax1.YAxis(1).FontSize=ft_size-2; 
ax1.XAxis(1).FontSize=ft_size-2; 

hold on
plot([frame_time,frame_time],ax1.YLim,'k')
img_name=[savedir,'suds_hr007.svg'];
saveas(fig,img_name);
img_name=[savedir,'suds_hr007.png'];
saveas(fig,img_name);
