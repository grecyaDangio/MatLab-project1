clear all;  
close;  
clc;

turbina= readtable('../DataSet/dati_puliti.csv');
train_data = readtable('../DataSet/train.csv');
test_data = readtable('../DataSet/dati_puliti_test.csv');
turbina.Properties.VariableNames(1:4) = {'wp1','ws','wd','hors'};
test_data.Properties.VariableNames(1:4) = {'wp1','ws','wd','hors'};


cutin_windspeed = 1;
cutout_windspeed = 13;
% 
datainrange = train_data(train_data.ws > cutin_windspeed & train_data.ws <= cutout_windspeed, :);
[theta, sigma] = lscov(datainrange.ws.^3, datainrange.wp1);
Y_Hat = datainrange.ws.^3 * theta;
% 
% 
% %Nella sezione di saturazione per completare il modello su tutto l'intervallo di velocità del vento, uso il valore medio delle saturazioni vere e lo applico 
% %da quando la curva cubica supera il livello di saturazione
% 
 saturationValue = mean(train_data(train_data.ws > 13 , :).wp1);
% 
% 
density = 0.01;
saturationWindspeed = density * floor(((saturationValue / theta) ^ (1/3))*(1/density));
windspeedGrid = [0 : density : 25]';



figure;
scatter(train_data.ws, train_data.wp1, '.', 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
hold on;
grid on;
plot(windspeedGrid, benchmark_model(windspeedGrid, theta, saturationWindspeed, saturationValue), "LineWidth", 2.5);
title('Benchmark Model with clear date: $P(v) = \theta v^3$', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]');
ylabel('Power [kW]');
legend("Training Data", "Benchmark Model");

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

%Goodness of git (GOF) con dati pultiti

% phi_cubo=[ ones(length(Y_Hat_test), 1),test_data.wp1, test_data.ws, test_data.wp1.^2,test_data.ws.^2, test_data.wp1.^3,test_data.ws.^3, ...
%     test_data.wp1.*test_data.ws, (test_data.wp1.^2).*test_data.ws, (test_data.ws.^2).*test_data.wp1];
% 
% thetaGOF = lscov(phi_cubo,test_data.wp1);
% figure;
% scatter(test_data.wp1, Y_Hat_test, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
% grid on;
% hold on;
% plot([0, 1], [0,1], 'LineWidth', 2);
% plot([0, 1], thetaGOF(1) + thetaGOF(2)*[0,1], 'LineWidth', 2);
% axis([0, 1, 0, 1]);
% title('Goodness of fit for Benchmark Model: $P(v) = \theta v^3$', 'Interpreter', 'latex');
% xlabel('Actual Power [Kw]');
% ylabel('Estimated Power [kW]');
% legend("Data vs. Estimates", "$45^{\circ}$ line", "Linear Regression", "Interpreter", 'latex');


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
