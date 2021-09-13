subject_lc = 'adbs005';
subject_email = strcat('bcm', subject_lc, '@gmail.com');

type = 'Intensity of OCD';

% get dates of OCD intensity readings
rune_data = readtable('events_20210512-100029.csv');
intensity_unix =  double(table2array(rune_data(:,1)));
intensity_rows = find(strcmp(rune_data.event_enum,'ocd')); 

for i = 1:length(intensity_rows)
    j = intensity_rows(i);
    helper = (strfind(rune_data.payload(j),'intensity'));
    ind = helper{1};
    helper2 = rune_data.payload{j}((ind+12):(ind+14));
    helper3 = (regexp(helper2,'\d*','Match'));
    rating_temp = str2double(helper3{1});
    SUDS.ratings(i) = rating_temp;
    time_temp = datetime(intensity_unix(j),'ConvertFrom','posixTime','TimeZone','America/Chicago','Format','dd-MMM-yyyy HH:mm:ss.SSS');
    SUDS.times(i) = time_temp;
end

datetime1 = datetime(dates{1},'TimeZone','America/Chicago')+hours(0)+minutes(0)+seconds(0);
datetime2 = datetime(dates{end},'TimeZone','America/Chicago')+hours(23)+minutes(59)+seconds(59);
del = find(~and(SUDS.times > datetime1,SUDS.times<datetime2));

SUDS.ratings(del) = [];
SUDS.times(del) = [];

c = [141,211,199]/255;
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



