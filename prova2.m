close all; 
clc; 
clear;
turbine =load('clean_dataset.mat');
dati_grezzi = readtable('train.csv');

figure;
scatter([dati_grezzi.ws; dati_grezzi.ws], [dati_grezzi.turbine_wp1; dati_grezzi.turbine_wp1], '.', 'MarkerEdgeColor', '#D95319');
hold on;
scatter(turbine.ws, turbine.wp1, '.', 'MarkerEdgeColor', '#0072BD');
grid on;
title('Clean data from both turbine', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]', "Interpreter", 'latex');
ylabel('Generated Power [kW]', "Interpreter", 'latex');
legend("Detected Outliers", "Clean Data", "Interpreter", 'latex');