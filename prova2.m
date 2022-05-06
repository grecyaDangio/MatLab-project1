
close all;
clc; 
clear;
turbina= load ('clean_dataset.mat');
dati_grezzi = readtable('train.csv');


figure;
scatter(dati_grezzi.ws,dati_grezzi.wp1, '.', 'MarkerEdgeColor', '#D95319');
hold on;
scatter(turbina.turbine.ws, turbina.turbine.wp1, '.', 'MarkerEdgeColor', '#0072BD');
grid on;
title('Clean data from the turbine');
xlabel('Wind Speed [m/s]');
ylabel('Generated Power [kW]');
legend("Detected Outliers", "Clean Data");