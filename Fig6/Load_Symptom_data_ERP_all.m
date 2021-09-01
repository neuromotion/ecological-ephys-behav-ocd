% get dates of OCD intensity readings
rune_data = readtable([data_folder,date,'_CBT_SUDS_',subject_id,'.xlsx']);
intensity_unix =  double(table2array(rune_data(:,1)));
intensity_rows = 1:height(rune_data); 

for i = 1:length(intensity_rows)
    rating_temp = rune_data.ratings(i);
    SUDS.ratings(i) = rating_temp;
    time_temp = datetime(intensity_unix(i),'ConvertFrom','posixTime','TimeZone','America/Chicago','Format','dd-MMM-yyyy HH:mm:ss.SSS');
    SUDS.times(i) = time_temp;
end

datetime1 = datetime(dates{1},'TimeZone','America/Chicago')+hours(0)+minutes(0)+seconds(0);
datetime2 = datetime(dates{end},'TimeZone','America/Chicago')+hours(23)+minutes(59)+seconds(59);
del = find(~and(SUDS.times > datetime1,SUDS.times<datetime2));

SUDS.ratings(del) = [];
SUDS.times(del) = [];

 
if and(strcmp(subject_id,'aDBS004'),d>=11)
    SUDS.times = SUDS.times + hours(6);
else
    SUDS.times = SUDS.times + hours(5);
end

c_all = [175,222,105;141,211,199;251,128,114]/255;

if strcmp(subject_id,'aDBS004')
    c = c_all(1,:);
elseif strcmp(subject_id,'aDBS005')
c = c_all(2,:);
elseif strcmp(subject_id,'aDBS007')
    c = c_all(3,:);
end
f = figure;
f.Units = 'inches';
f.Position = [1,1,12,2.5];

SUDS_times_norm = hours(SUDS.times - SUDS.times(1));
scatter(SUDS_times_norm,SUDS.ratings,'filled','MarkerFaceColor',c)
ax1 = gca;
ax1.FontSize = 13;
ylabel({'P4';'Self-Reported Intensity';'of OCD Symptoms'},'FontSize',13)
xlabel('Hours','FontSize',13)
hold on;



