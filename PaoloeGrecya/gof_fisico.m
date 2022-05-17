clc; clear; close all;

train = readtable ('train.csv'); %%%%%%%%%%%%%%%%%%CAMBIATO I NOMI: TEST TO TRAIN (SONO DATI DI TRAIN); ATT: CAMBIATA LA PROVENIENZA DEL FILE TRAIN.CSV
wp = train.wp1;
ws = train.ws;
wd = pi/180 * train.wd;
%% cancello 1 e 0
ws = ws(wp ~= 0 & wp ~= 1);
wd = wd(wp ~= 0 & wp ~= 1);
wp = wp(wp ~= 0 & wp ~= 1);

figure(1)
scatter(ws, wp, 'x');
title('scatter dati senza 0 e 1') % tolgo gli 0 e gli 1 per far funzionare la logit
xlabel('ws');
ylabel('wp');

%% logit
wpl = log(wp./(1-wp)); % faccio la logit dei dati, wpl = wp con logit
figure(2)
scatter(ws, wpl, 'x');
title('scatter dati trasformati')
xlabel('ws');
ylabel('logit wp');

%% filtraggio righe
ws = ws(wpl > -4 & wpl < 4);
wd = wd(wpl > -4 & wpl < 4);
wp = wp(wpl > -4 & wpl < 4);
wpl = wpl(wpl > -4 & wpl < 4);
figure(3)
scatter(ws, wpl, 'x');
title('scatter dati puliti')
xlabel('ws filtrato');
ylabel('logit wp filtrato');
hold on

%% Modello fisico
% y = ws; x = wp;
%chiedere perchè il parametro stimato viene 0.0028 e non circa 2500*pi*1.225
%perchè rmse sono molto differenti fra identificazione e validazione
%(0.5*(rA*ws.^3)); %my_fun modello teorico @ parametri che si passano

%% Modello fisico

%stima LS con dati trasformati
phith = ws.^3;
[rA, devrA] = lscov(phith,wpl);
%antitrasformo
wpeth = 1/2 * rA * ws.^3;


figure(10)
scatter(ws, wp, 'x');
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpeth, '.', 'yellow')
title('modello teorico con identificazione lineare')

%GOF modello cubico 
thetaGOF = lscov([ ones(length(yth), 1), wpl], yth);

figure;
scatter(wpl, yth, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
grid on;
hold on;
plot([-3, 3], [-3,3], 'LineWidth', 2);
plot([-3, 3], thetaGOF(1) + thetaGOF(2)*[-3,3], 'LineWidth', 2);
axis([-3, 3, -3, 3]);
title('Goodness of fit for Model: $P(w_s) = 1/2 \cdot \rho \cdot A \cdot w_s^3 $ ', 'Interpreter', 'latex');
xlabel('Actual Power [kW]', "Interpreter", 'latex');
ylabel('Estimated Power [kW]', "Interpreter", 'latex');
legend("Data vs. Estimates", "$45^{\circ}$ line", "Regression Line", "Interpreter", 'latex');