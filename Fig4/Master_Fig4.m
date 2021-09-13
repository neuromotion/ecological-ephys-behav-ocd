close all;
clear all;
loaddir = 'C:\Users\Nicol\OneDrive\Documents\Data\platform-paper-data\Fig4\';
savedir = 'C:\Users\Nicol\OneDrive\Documents\Results\Fig4\';
addpath(genpath(loaddir))
addpath(genpath(savedir))

% Panel A
plot_rune_ratings_ybocs;

% Panel C
calendarPlot;

% Panel D
sprint_recording_example;

