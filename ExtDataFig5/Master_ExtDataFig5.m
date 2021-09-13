close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig5\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig5\';
addpath(genpath(loaddir))
addpath(genpath(savedir))

% panel A
calendarPlot007;

%panel C
suds_hr_panel007;

%panel D
example_data_CBT_007;
