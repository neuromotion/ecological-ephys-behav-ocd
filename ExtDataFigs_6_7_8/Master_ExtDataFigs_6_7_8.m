% specify subject ID
subject_id = 'P5';

data_path = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFigs_6_7_8\';
om_repo = 'C:\Users\Nicol\OneDrive\Documents\GitHub\Analysis-rcs-data\';
results_path = 'C:\Users\Nicol\OneDrive\Documents\Results\';
final_figure_path_base = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig';

%% 
if strcmp(subject_id,'P3')
    final_figure_path = [final_figure_path_base,'6\'];
elseif strcmp(subject_id,'P4')
    final_figure_path = [final_figure_path_base,'7\'];
elseif strcmp(subject_id,'P5')
    final_figure_path = [final_figure_path_base,'8\'];
end
%% set paths
data_folder = [data_path,subject_id,'-CBT-ratings\'];
addpath(genpath(data_folder));
LFP_data_folder = [data_path,subject_id,'-LFP\'];
addpath(genpath(LFP_data_folder));
addpath(genpath([om_repo,'\code\']))
addpath(genpath(results_path));
wd = pwd;
addpath(genpath(wd))
addpath(genpath(final_figure_path))
% set and add path to where figures will be saved
figure_path = [results_path,subject_id,'/figures/'];
if ~exist(figure_path)
    mkdir(figure_path)
end
addpath(genpath(figure_path))

% list of frequencies for spectral power analysis
load('frequency.mat')

% plotting color
lfp_color = [255,127,0]/255;

%% get list of dates
tab = readtable([data_folder,subject_id,'-dates.xlsx']);
all_dates = tab.alldates;

%% for loop for date of interest
for d = 1:length(all_dates)
    date_str_i = datestr(all_dates(d),'yyyy-mm-dd');
    dates = {date_str_i};
    
    % set results folder name
    results_name = [results_path,subject_id,'\resultsERP_',subject_id,'_',dates{1},'\'];
    addpath(genpath(results_name));
    
    if ~exist([results_name])
        mkdir([results_name]);
    end
    
    Load_analyze_LFP;
    plot_results;
end
