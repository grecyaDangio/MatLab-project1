clear;  close;  clc;
test = readtable('train.csv');

%% scatter plot con due variabili 

%schiribizzinibici

figure(1)
lin_wp1 = log(test.wp1 ./ (1-test.wp1));