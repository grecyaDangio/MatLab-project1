clear all;  
close;  
clc;
train = readtable('../DataSet/train.csv');
train_data= load('logit_nuovo.mat');

train_data_wp=train_data(:,1);
train_data_ws=train_data(:,2);

%clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
%wl= without logit 
%no vpa

cl_wp_wl= train.wp1(train.wp1 > 0 & train.wp1  ~= 1);
cl_ws_wl= train.ws(train.wp1 > 0 & train.wp1  ~= 1);
% cl_wd_wl= train.wd(train.wp1 > 0 & train.wp1  ~= 1);
% cl_wh_wl= train.hors(train.wp1 > 0 & train.wp1  ~= 1);

logit_wp1 = (log(cl_wp_wl ./ (1-cl_wp_wl)));
logit_wp = vpa(log(train.wp1 ./ (1-train.wp1)));   %logit con dati sporchi

wp= logit_wp1( logit_wp1 > -4 & logit_wp1<4 );
ws= train.ws(logit_wp1 > -4 & logit_wp1<4);
% cl_wd= train.wd(logit_wp1 > -3.5 & logit_wp1<3);
% cl_wh= train.hors(logit_wp1 > -3.5 & logit_wp1<3);



figure(1)
scatter(cl_ws_wl,logit_wp1,'.', 'r');
title('Dati puliti 1 con logit')

% 
figure(2)
plot(ws, wp, '.')
grid on
title('Dati puliti e con logit')
xlabel('velocità del vento (ws)')
ylabel('potenza(wp1')
% 

%% modelli con logit

cutin_windspeed = 1;
cutout_windspeed = 13;

datainrange = train_data(train_data_wp > cutin_windspeed & train_data.ws <= cutout_windspeed, :);
[theta, sigma] = lscov(datainrange.train_data_ws.^3, datainrange.train_data_wp);
Y_Hat = datainrange.ws.^3 * theta;
% 
% 
% %Nella sezione dtri saturazione per completare il modello su tutto l'intervallo di velocità del vento, uso il valore medio delle saturazioni vere e lo applico 
% %da quando la curva cubica supera il livello di saturazione
% 
 saturationValue = 0.9824;
 
% 
% 
density = 0.01;
saturationWindspeed = density * floor(((saturationValue / theta) ^ (1/3))*(1/density));
windspeedGrid = [0 : density : 25]';
% 
% 
% 
figure;
scatter(train_data_ws, train_data_wp, '.', 'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
hold on;
grid on;
plot(windspeedGrid, benchmark_model(windspeedGrid, theta, saturationWindspeed, saturationValue), "LineWidth", 2.5);
title('Benchmark Model: $P(v) = \theta v^3$', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]');
ylabel('Power [kW]');
legend("Training Data", "Benchmark Model");
% 
% %predizione si dati di train 
% 
Y_Hat_train = benchmark_model(train_data_ws, theta, saturationWindspeed, saturationValue);
% 
figure;
scatter(train_data_ws, train_data_wp, '.');
hold on;
grid on;
scatter(train_data_ws, Y_Hat_train, '.');
title('Validation for Benchmark Model: $P(v) = \frac{1}{2}\rho Av^3$', 'Interpreter', 'latex');
xlabel('Wind Speed [m/s]');
ylabel('Power [kW]');
legend("Validation Data", "Estimates");
% 
% 
% %Goodness of git (GOF)
% 
thetaGOF = lscov([ ones(length(Y_Hat_train), 1), Y_Hat_train], train_data_wp);
% 
figure;
scatter(train_data_wp, Y_Hat_train, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
grid on;
hold on;
plot([0, 1], [0,1], 'LineWidth', 2);
plot([0, 1], thetaGOF(1) + thetaGOF(2)*[0,1], 'LineWidth', 2);
axis([0, 1, 0, 1]);
title('Goodness of fit for Benchmark Model: $P(v) = \theta v^3$', 'Interpreter', 'latex');
xlabel('Actual Power [Kw]');
ylabel('Estimated Power [kW]');
legend("Data vs. Estimates", "$45^{\circ}$ line", "Linear Regression", "Interpreter", 'latex');

% 
% benchmarkModel.parameters = theta;
% benchmarkModel.standardDeviation = sigma;
% benchmarkModel.confidenceIntervals = [theta - 1.96 * sigma, theta + 1.96*sigma];
% 
% benchmarkModel.SSR = sum((datainrange.wp1 - Y_Hat).^2);
% benchmarkModel.MSE = (1/length(Y_Hat)) * benchmarkModel.SSR;
% 
% benchmarkModel.FPE = ((length(Y_Hat) + length(theta))/(length(Y_Hat) - length(theta))) * benchmarkModel.SSR ;
% benchmarkModel.AIC = (2*length(theta) / length(Y_Hat)) * log(benchmarkModel.SSR);
% benchmarkModel.MDL = (log(length(Y_Hat))*length(theta) / length(Y_Hat)) * log(benchmarkModel.SSR);
% 
% benchmarkModel.ValidationSSR = sum((train_data(:,1)1 - Y_Hat_train).^2);
% benchmarkModel.ValidationMSE = benchmarkModel.ValidationSSR / length(Y_Hat_train);
% 
% benchmarkModel.MAE = (sum(abs(train_data(:,1)1 - Y_Hat_train))) / (length(Y_Hat_train));
% benchmarkModel.WMAPE = sum(abs(train_data(:,1)1 - Y_Hat_train)) / sum(abs(train_data(:,1)1));
% benchmarkModel.NRMSE = sqrt(benchmarkModel.ValidationMSE) / (max(train_data(:,1)1) - min(train_data(:,1)1));

