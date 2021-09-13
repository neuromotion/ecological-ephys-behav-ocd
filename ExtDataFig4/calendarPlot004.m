load([loaddir,'cbt_dates.mat'])

ERP_video = cbt.aDBS004.cbt_dates - cbt.aDBS004.cbt_dates(1);
accelWatch = ERP_video;
del = [1:13];
accelWatch(del) = [];

hrWatch = ERP_video;
del = [1:13]
hrWatch(del) = [];

accelRC = ERP_video;
accelRC(5:6) = [];

lfpRC = ERP_video;
lfpRC(5:6) = [];

minTime=days(min(ERP_video));
maxTime=days(max(ERP_video))+1;

dur=days(maxTime-minTime);
timeBlocks=minTime:maxTime;
calMat=zeros(4,length(timeBlocks));
for i=1:length(ERP_video)
    calMat(1,[timeBlocks(2:end)>=ERP_video(i),0]&timeBlocks<=ERP_video(i))=1;
end
for i=1:size(accelWatch,1)
    calMat(2,[timeBlocks(2:end)>=accelWatch(i),0]&timeBlocks<=accelWatch(i))=2;
end
for i=1:size(hrWatch,1)
    calMat(3,[timeBlocks(2:end)>=hrWatch(i),0]&timeBlocks<=hrWatch(i))=3;
end
for i=1:size(accelRC,1)
    calMat(4,[timeBlocks(2:end)>=accelRC(i),0]&timeBlocks<=accelRC(i))=4;
end
for i=1:size(lfpRC,1)
    calMat(5,[timeBlocks(2:end)>=lfpRC(i),0]&timeBlocks<=lfpRC(i))=5;
end


f = figure('Color','w')
f.Units = 'inches';
    f.Position = [1,1,12,2];
    f.PaperPosition = [1,1,12,2];

colormap([255,255,255;...%not available
    251,180,174; ... %video
    140,150,198;...% motion
    31,120,180;...%heart rate
    140,107,177;...%RC+S motion
    255,127,0]/255);%LFP
    
calMat = double(calMat);
imagesc(calMat,'XData',[0,maxTime])
yticks(1:5)
yticklabels({'Video','Apple Watch Heart Rate','Apple Watch Accel.','RC+S Accel.','RC+S LFP'})
box off
ax1=gca;
ax1.FontSize = 12;
ax1.YAxis.TickLength=[0,0];
xlabel('Days')
hold on
time = (timeBlocks-minTime);
int_helper = calMat(5,:);
x_helper = time(find(int_helper))

saveas(f,[savedir,'erp-cal-plot004.svg'])
saveas(f,[savedir,'erp-cal-plot004.jpg'])
