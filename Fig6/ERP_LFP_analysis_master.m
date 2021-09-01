% specify subject ID
subject_id = 'aDBS004';

% set path to folder that contains excel sheets with SUDs ratings from ERP
% sessions. There should be one excel sheet for each ERP session, where the
% title is in the following format: [YYYY-MM-DD]_CBT_SUDS_[subject_id].xlsx
% [subject_id]-dates.xlsx is an excel sheet containing a list of date(s) of
% all sessions included in analysis
data_folder = ['D:\Users\Nicole\platform-paper\CBT\LFP-analysis-data-results\',subject_id,'-CBT-ratings\'];

%% set paths

addpath(genpath(data_folder));

% set path to OpenMind analysis-rcs-data github repository
addpath(genpath('D:\GitHub_remote\Analysis-rcs-data\code\'))

wd = pwd;
addpath(genpath(wd))

% list of frequencies for spectral power analysis (used in hamming
% function)
load('frequency.mat')

% set path to folder where results should be saved locally
results_path = 'D:\Users\Nicole\platform-paper\CBT\LFP-analysis-data-results';
addpath(genpath(results_path));

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
    results_name = ['/',subject_id,'/resultsERP_',subject_id,'_',dates{1},'/'];
    
    % set and add path to where figures will be saved
    figure_path = ['D:\Users\Nicole\platform-paper\CBT\LFP-analysis-data-results/',subject_id,'/figures/'];
    addpath(genpath(figure_path))

    if ~exist([results_path,results_name])
        mkdir([results_path,results_name]);
    end
    
    Load_analyze_LFP;
end
