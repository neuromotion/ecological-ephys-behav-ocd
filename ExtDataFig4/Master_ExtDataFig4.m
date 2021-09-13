close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\ExtDataFig4\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\ExtDataFig4\';
addpath(genpath(loaddir))
addpath(genpath(savedir))

% panel A
calendarPlot004;

%panel C
suds_hr_panel004;

%panel D
example_data_CBT_004;
