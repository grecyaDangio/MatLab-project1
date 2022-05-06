
close all;
clc; 
clear;
turbina= load ('clean_dataset.mat');
train_data = readtable('train.csv');
test_data = readtable('test.csv');

%%
% 
% figure;
% scatter(train_data.ws,train_data.wp1, '.', 'MarkerEdgeColor', '#D95319');
% hold on;
% scatter(turbina.turbine.ws, turbina.turbine.wp1, '.', 'MarkerEdgeColor', '#0072BD');
% grid on;
% title('Clean data from the turbine');
% xlabel('Wind Speed [m/s]');
% ylabel('Generated Power [kW]');
% legend("Detected Outliers", "Clean Data");
% 
% 
% %%
% figure;
% scatter(train_data.ws, train_data.wp1, '.');
% grid on;
% title('Identification Set');
% xlabel('Windspeed [m/s]');
% ylabel('Generated Power [kW]');
% 
% figure;
% scatter(test_data.ws, test_data.wp1, '.', 'r');
% grid on;
% title('Test Set');
% xlabel('Wind Speed [m/s]');
% ylabel('Generated Power [kW]');
% 
% % figure;
% % scatter(val_data.ws, val_data.wp1, '.');
% % grid on;
% % title('Validation Set');
% % xlabel('Wind Speed [m/s]');
% % ylabel('Generated Power [kW]');


%% Modello di Benchmark (cut-in e cut-out)
cutin_windspeed = 1;
cutout_windspeed = 13;

datainrange = train_data(train_data.ws > cutin_windspeed & train_data.ws <= cutout_windspeed, :);
[theta, sigma] = lscov(datainrange.ws.^3, datainrange.wp1);
Y_Hat = datainrange.ws.^3 * theta;


%Nella sezione di saturazione per completare il modello su tutto l'intervallo di velocità del vento, uso il valore medio delle saturazioni vere e lo applico 
%da quando la curva cubica supera il livello di saturazione;
saturationValue = mean(train_data(train_data.ws > 13 , :).wp1);


density = 0.01;
saturationWindspeed = density * floor(((saturationValue / theta) ^ (1/3))*(1/density));
windspeedGrid = [0 : density : 25]';



figure;
scatter(train_data.ws, train_data.wp1, '.', 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
hold on;
grid on;
plot(windspeedGrid, benchmark_model(windspeedGrid, theta, saturationWindspeed, saturationValue), "LineWidth", 2.5);
title('Benchmark Model: $P(v) = \theta v^3$', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]');
ylabel('Power [kW]');
legend("Training Data", "Benchmark Model");

%predizione si dati di test 

Y_Hat_test = benchmark_model(test_data.ws, theta, saturationWindspeed, saturationValue);

figure;
scatter(test_data.ws, test_data.wp1, '.');
hold on;
grid on;
scatter(test_data.ws, Y_Hat_test, '.');
title('Validation for Benchmark Model: $P(v) = \frac{1}{2}\rho Av^3$', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]');
ylabel('Power [kW]');
legend("Validation Data", "Estimates");


%Goodness of git (GOF)

thetaGOF = lscov([ ones(length(Y_Hat_test), 1), Y_Hat_test], test_data.wp1);

figure;
scatter(test_data.wp1, Y_Hat_test, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
grid on;
hold on;
plot([0, 1], [0,1], 'LineWidth', 2);
plot([0, 1], thetaGOF(1) + thetaGOF(2)*[0,1], 'LineWidth', 2);
axis([0, 1, 0, 1]);
title('Goodness of fit for Benchmark Model: $P(v) = \theta v^3$', 'Interpreter', 'latex');
xlabel('Actual Power [Kw]');
ylabel('Estimated Power [kW]');
legend("Data vs. Estimates", "$45^{\circ}$ line", "Linear Regression", "Interpreter", 'latex');


benchmarkModel.parameters = theta;
benchmarkModel.standardDeviation = sigma;
benchmarkModel.confidenceIntervals = [theta - 1.96 * sigma, theta + 1.96*sigma];

benchmarkModel.SSR = sum((datainrange.wp1 - Y_Hat).^2);
benchmarkModel.MSE = (1/length(Y_Hat)) * benchmarkModel.SSR;

benchmarkModel.FPE = ((length(Y_Hat) + length(theta))/(length(Y_Hat) - length(theta))) * benchmarkModel.SSR ;
benchmarkModel.AIC = (2*length(theta) / length(Y_Hat)) * log(benchmarkModel.SSR);
benchmarkModel.MDL = (log(length(Y_Hat))*length(theta) / length(Y_Hat)) * log(benchmarkModel.SSR);

benchmarkModel.ValidationSSR = sum((test_data.wp1 - Y_Hat_test).^2);
benchmarkModel.ValidationMSE = benchmarkModel.ValidationSSR / length(Y_Hat_test);

benchmarkModel.MAE = (sum(abs(test_data.wp1 - Y_Hat_test))) / (length(Y_Hat_test));
benchmarkModel.WMAPE = sum(abs(test_data.wp1 - Y_Hat_test)) / sum(abs(test_data.wp1));
benchmarkModel.NRMSE = sqrt(benchmarkModel.ValidationMSE) / (max(test_data.wp1) - min(test_data.wp1));

%%Modelli cubici
%Un modello di riferimento è quello cubico, con cui si modellizza il tratto
%crescente con un modello: P=\theta_1 +\theta_2 v+\theta_3 v^{2\;} +\theta_4 v^3

cutin_windspeed = 2;
cutout_windspeed = 12.5;

datainrange = train_data(train_data.wp1 < cutout_windspeed & train_data.wp1 > cutin_windspeed, :);

PHI = [ones(length(datainrange.wp1), 1), datainrange.wp1, datainrange.wp1.^2, datainrange.wp1.^3];
[theta, sigma] = lscov(PHI, train_data.wp1);
Y_Hat = PHI*theta;



