# ecological-ephys-behav-ocd
Custom Matlab code used to analyze data and create figures for the manuscript "Long-term ecological assessment of intracranial electrophysiology synchronized to behavioral markers in Obsessive-Compulsive Disorder."

## Step 1:
Run `ERP_LFP_analysis_master.m` to analyze data. To do so, you will first need to clone the rcs-analysis repository to your local machine ([https://github.com/openmind-consortium/Analysis-rcs-data](https://github.com/openmind-consortium/Analysis-rcs-data)). You will also need to configure folder names/paths of where data will be loaded from and saved to, and set the paths on your machine (lines 9-27). Comments in the `.m` file describe the data formats required. 

## Step 2:
Run `plot_master.m` to generate figures. The same folders/paths need to be set as described in Step 1.
