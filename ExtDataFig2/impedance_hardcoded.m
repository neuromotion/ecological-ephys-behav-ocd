% hardcoded impedance values
hard_coded_dates = [datetime(2019,12,5),datetime(2019,12,19),datetime(2020,1,3),datetime(2020,1,16),...
    datetime(2020,2,4)];
    
    hc_td11 = 1*ones(length(hard_coded_dates),1);
    hc_td12 = 3*ones(length(hard_coded_dates),1);
    hc_td21 = 8*ones(length(hard_coded_dates),1);
    hc_td22 = 10*ones(length(hard_coded_dates),1);
    hc_s1 = 2*ones(length(hard_coded_dates),1);
    hc_s2 = 9*ones(length(hard_coded_dates),1);
    
    hc_sense_impedance(1,1) = 2640;% 1, 3
    hc_sense_impedance(1,2) = 2550; % 8, 10
    hc_sense_impedance(1,3) = 1710;
    hc_sense_impedance(1,4) = 1570;
    hc_sense_impedance(1,5) = 1510;
    hc_sense_impedance(1,6) = 1445;
    hc_stim_impedance(1,1) = 1555;
    hc_stim_impedance(1,2) = 1693;

    hc_sense_impedance(2,1) = 2955;% 1, 3
    hc_sense_impedance(2,2) = 2065; % 8, 10
    hc_sense_impedance(2,3) = 1710;
    hc_sense_impedance(2,4) = 1755;
    hc_sense_impedance(2,5) = 1190;
    hc_sense_impedance(2,6) = 1265;
    hc_stim_impedance(2,1) = 1090;
    hc_stim_impedance(2,2) = 1005;

    hc_sense_impedance(3,1) = 2780; % 1, 3
    hc_sense_impedance(3,2) = 2830; % 8, 10
    hc_sense_impedance(3,3) = 1550;
    hc_sense_impedance(3,4) = 1665;
    hc_sense_impedance(3,5) = 1585;
    hc_sense_impedance(3,6) = 1625;
    hc_stim_impedance(3,1) = 1005;
    hc_stim_impedance(3,2) = 1090;

    hc_sense_impedance(4,1) = 2640; % 1, 3
    hc_sense_impedance(4,2) = 3010; % 8, 10
    hc_sense_impedance(4,3) = 1478;
    hc_sense_impedance(4,4) = 1665;
    hc_sense_impedance(4,5) = 1665;
    hc_sense_impedance(4,6) = 1830;
    hc_stim_impedance(4,1) = 1005; %2
    hc_stim_impedance(4,2) = 1080; %9

    hc_sense_impedance(5,1) = 2835; % 1, 3
    hc_sense_impedance(5,2) = 3030; % 8, 10
    hc_sense_impedance(5,3) = 1628;
    hc_sense_impedance(5,4) = 1665;
    hc_sense_impedance(5,5) = 1765;
    hc_sense_impedance(5,6) = 1740;
    hc_stim_impedance(5,1) = 1005; %2
    hc_stim_impedance(5,2) = 1005; %9
    
    Imp_all_cat = [hc_sense_impedance,hc_stim_impedance];
    
    Imp_all = [Imp_all_cat;Imp_all];
    dates = [hard_coded_dates';dates];
    td11 = [hc_td11;td11];
    td12 = [hc_td12;td12];
    td21 = [hc_td21;td21];
    td22 = [hc_td22;td22];
    stimChan1 = [hc_s1;stimChan1];
    stimChan2 = [hc_s2;stimChan2];
    
