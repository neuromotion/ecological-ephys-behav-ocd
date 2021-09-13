# ecological-ephys-behav-ocd
Custom Matlab code used to analyze data and create figures for the manuscript "Long-term ecological assessment of intracranial electrophysiology synchronized to behavioral markers in Obsessive-Compulsive Disorder." In this repository, there is a folder that contains code to produce each figure in the manuscript (barring the illustration in Figure 1 and the MMVT diagrams in Figure 2 and Extended Data Figure 1). All code is written in MATLAB, and runs on MATLAB R2020b. 

There is a Master script in each folder in the repository, labeled with the prefix 'Master_'. Running the Master script will reproduce all the panels in the figure. The following sections describe how to edit the load/save directories needed to run the code. Please note that all of the directories you set in the code need to be created on your local machine for the code to run. 


# Main Text Figures

## Figure 3
Open the `Fig3` folder. In `Master_Fig3.m`, update the data directory (`load_dir`) and the save directory (`save_dir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_Fig3.m` to reproduce Figure 3. Note that the images showing the participant's face will not be reproduced. 

## Figure 4
Open the `Fig4` folder. In `Master_Fig4.m`, update the data directory (`loaddir`) and the save directory (`savedir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_Fig4.m` to reproduce Figure 4. Note that the bar plot showing hours of LFP will not be reproduced, as we have not made all of this data available. 

## Figure 5
Open the `Fig5` folder. In `Master_Fig5.m`, update the data directory (`loaddir`) and the save directory (`savedir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_Fig5.m` to reproduce Figure 5. Note that the images showing screenshots from the ERP video will not be reproduced. 

## Figure 6
To reproduce Figure 6, you will first need to clone the rcs-analysis repository to your local machine ([https://github.com/openmind-consortium/Analysis-rcs-data](https://github.com/openmind-consortium/Analysis-rcs-data)).

Open the `Fig6` folder. In `Master_Fig6.m`, update the data directory (`data_path`), the path to the rcs-analysis repository (`om_repo`), the path to where intermediate resutls files will be saved (`results_path`), and the `final_figure_path` where the final panels of the figure will be saved (lines 4-7). Run `Master_Fig6.m` to reproduce Figure 6.


# Extended Data Figures

## Extended Data Figure 2
Open the `ExtData2` folder. In `Master_ExtDataFig2.m`, update the data directory (`load_dir`) and the save directory (`save_dir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_ExtDataFig2.m` to reproduce Extended Data Figure 2.

## Extended Data Figure 3
Open the `ExtData3` folder. In `Master_ExtDataFig3.m`, update the data directory (`loaddir`) and the save directory (`savedir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_ExtDataFig3.m` to reproduce Extended Data Figure 3.

## Extended Data Figure 4
Open the `ExtData4` folder. In `Master_ExtDataFig4.m`, update the data directory (`loaddir`) and the save directory (`savedir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_ExtDataFig4.m` to reproduce Extended Data Figure 4. Note that the images showing screenshots from the ERP video will not be reproduced. 

## Extended Data Figure 5
Open the `ExtData5` folder. In `Master_ExtDataFig5.m`, update the data directory (`loaddir`) and the save directory (`savedir`) with where you would like to load data from and save data to on your local machine (Lines 3-4). Run `Master_ExtDataFig5.m` to reproduce Extended Data Figure 5. Note that the images showing screenshots from the ERP video will not be reproduced. 

## Extended Data Figures 6, 7, and 8
To reproduce Extended Data Figures 6, 7, and 8, you will first need to clone the rcs-analysis repository to your local machine ([https://github.com/openmind-consortium/Analysis-rcs-data](https://github.com/openmind-consortium/Analysis-rcs-data)).

Open the `ExDataFigs_6_7_8` folder. In `Master_ExtDataFigs_6_7_8.m`, update the data directory (`data_path`), the path to the rcs-analysis repository (`om_repo`), the path to where intermediate resutls files will be saved (`results_path`), and the `final_figure_path_base` where the final panels of the figure will be saved (lines 4-7). Edit `subject` to reproduce each figure: P3 --> Ext Data Figure 6, P4 --> Ext Data Figure 7, P5 --> Ext Data Figure 8. Run `Master_ExtDataFigs_6_7_8.m` to reproduce Figures 6, 7, and 8.
