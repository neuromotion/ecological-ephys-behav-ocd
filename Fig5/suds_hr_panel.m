
%%
c = [31,120,180]/255;

fig = figure('Color','w','Renderer','painters','Position',[0,0,600,200]);

suds = xlsread([loaddir,'9-11 aDBS005 SUDs ratings (1).xlsx']);

suds_times = NaT(length(suds),1,'TimeZone','America/Chicago');
for i = 1:length(suds)
    H = suds(i,1);
    M = suds(i,2);
    S = suds(i,3);
    suds_times(i) = datetime(2020,9,11,H,M,S,'TimeZone','America/Chicago');
end

hr = csvread([loaddir,'Strive-Study-aDBS005_aDBS005-Apple-Watch_heartrate_1599852032248_1599856920509.csv']);
hr_bpm = hr(:,2);
hr_dates = datetime(hr(:,1),'ConvertFrom','posixtime','TimeZone','America/Chicago');

starttime = suds_times(1);
suds_time_s = minutes(suds_times - starttime);
HR_times = minutes(hr_dates-starttime);
ft_size=14;

yyaxis left
ax1 = gca;
plot(suds_time_s,suds(:,4),'k-o','LineWidth',1.2,'MarkerFaceColor','k')
set(ax1,{'ycolor'},{'k'});
ylabel('SUDs','fontsize',ft_size)
xlabel('Minutes','fontsize',ft_size)
ax1.YLim = [7,10.5];

yyaxis right
ax1 = gca;
plot(HR_times,hr_bpm,'Color',c(1,:),'LineWidth',1.2)
ylabel('Heart Rate','fontsize',ft_size)
set(ax1,{'ycolor'},{c(1,:)});
ax1.XLim = [-1,max(suds_time_s)+1];

ax1.YAxis(1).FontSize=ft_size-2; 
ax1.YAxis(2).FontSize=ft_size-2; 
ax1.XAxis(1).FontSize=ft_size-2; 

img_name=[savedir,'suds_hr.svg'];
saveas(fig,img_name);

img_name=[savedir,'suds_hr.png'];
saveas(fig,img_name);