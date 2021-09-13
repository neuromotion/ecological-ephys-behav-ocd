close all
clear all
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\Fig5\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\Fig5\';
addpath(genpath(loaddir))
addpath(genpath(savedir))
%%
% Panel A
calendarPlot;

% Panel C
suds_hr_panel;

% Panel D
example_data_CBT_005;