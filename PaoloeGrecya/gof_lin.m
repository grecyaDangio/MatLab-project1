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

%% modello lineare
% y = t1 + t2*x
% wp = t1 + t2*ws
phi = [ones(length(wpl), 1), ws];
[theta, dev] = lscov(phi, wpl);  % dev = deviazione standard
y1 = phi*theta;

% antitrasformo phi*theta
wpe = exp(phi*theta)./(1 + exp(phi*theta)); % wpe = wp estimated. tolgo la logit
epsilon = wp - wpe;
ssr = epsilon' * epsilon;
rmse = sqrt(ssr/length(wp));


figure(4)
scatter(ws, wp, 'x');
title('Modello lineare: $P(w_s) = t_1 + t_2 \cdot w_s$', 'Interpreter', 'latex');
xlabel('Actual Power [Kw]');
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe, '.' ,'yellow')


%GOF modello lineare 
thetaGOF = lscov([ ones(length(y1), 1), wpl], y1);

figure;
scatter(wpl, y1, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
grid on;
hold on;
plot([-3, 3], [-3,3], 'LineWidth', 2);
plot([-3, 3], thetaGOF(1) + thetaGOF(2)*[-3,3], 'LineWidth', 2);
axis([-3, 3, -3, 3]);
title('Goodness of fit for Model: $P(w_s) = t_1 + t_2 \cdot w_s$ ', 'Interpreter', 'latex');
xlabel('Actual Power [kW]', "Interpreter", 'latex');
ylabel('Estimated Power [kW]', "Interpreter", 'latex');
legend("Data vs. Estimates", "$45^{\circ}$ line", "Regression Line", "Interpreter", 'latex');


