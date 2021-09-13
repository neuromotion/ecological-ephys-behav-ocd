%%
accelWatch=csvread([loaddir,'epochs_accel.csv']);
accelWatch=accelWatch(2:end,2:end);
hrWatch=csvread([loaddir,'epochs_hr.csv']);
hrWatch=hrWatch(2:end,2:end);
accelRC=csvread([loaddir,'epochs_motion.csv']);
accelRC=accelRC(2:end,2:end);
lfpRC=csvread([loaddir,'epochs_neural.csv']);
lfpRC=lfpRC(2:end,2:end);

C = table2cell(readtable([loaddir,'strivestudy_patient_logs20200921.csv']));
subject='adbs005';
subject_email = ['bcm',subject,'@gmail.com'];
type = 'Intensity of OCD';
idx = find(and(strcmp(C(:,1),subject_email),strcmp(C(:,4),type)));
intensity_unix = cell2mat(C(idx,3));
intensity = cell2mat(C(idx,8));

minTime=min([accelWatch(:,1);hrWatch(:,1);accelRC(:,1);lfpRC(:,1)]);
maxTime=max([accelWatch(:,2);hrWatch(:,2);accelRC(:,2);lfpRC(:,2)]);

duration=maxTime-minTime;
timeBlocks=minTime:60*10:maxTime;
calMat=zeros(5,length(timeBlocks));

for i=1:size(accelWatch,1)
    calMat(2,timeBlocks>=accelWatch(i,1)&timeBlocks<=accelWatch(i,2))=1;
end
for i=1:size(hrWatch,1)
    calMat(1,timeBlocks>=hrWatch(i,1)&timeBlocks<=hrWatch(i,2))=2;
end
for i=1:size(accelRC,1)
    calMat(3,timeBlocks>=accelRC(i,1)&timeBlocks<=accelRC(i,2))=3;
end
for i=1:size(lfpRC,1)
    calMat(4,timeBlocks>=lfpRC(i,1)&timeBlocks<=lfpRC(i,2))=4;
end
for i=1:length(intensity_unix)
    calMat(5,[timeBlocks(2:end)>=intensity_unix(i),0]&timeBlocks<=intensity_unix(i))=5;
end

f = figure('Color','w')
f.Units = 'inches';
    f.Position = [1,1,12,2];
    f.PaperPosition = [1,1,12,2];

colormap([255,255,255;...%not available
    140,150,198;...% motion
    31,120,180;...%heart rate
    140,107,177;...%RC+S motion
    255,127,0;...%LFP
    255,255,255;]/255);%231,138,195]/255);%Intensity ratings
    
imagesc(calMat,'XData',[0,duration/(60*60)])
yticks(1:5)
yticklabels({'Apple Watch Heart Rate','Apple Watch Accel.','RC+S Accel.','RC+S LFP','OCD Intensity Ratings'})
box off
ax1=gca;
ax1.FontSize = 12;
ax1.YAxis.TickLength=[0,0];
xlabel('Hours')
hold on
time = (timeBlocks-minTime)/(60*60);
int_helper = calMat(5,:);
x_helper = time(find(int_helper))
scatter(x_helper,5*ones(size(x_helper)),'*k')
saveas(f,[savedir,'sprint-cal-plot.svg'])
saveas(f,[savedir,'sprint-cal-plot.jpg'])

