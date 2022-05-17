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

%% modello quadratico
% y = t1 + t2*ws +t3*ws^2
% wp = t1 + t2*ws
phi2 = [ones(length(wpl), 1), ws, ws.^2];
[theta2, dev2] = lscov(phi2, wpl);  % dev = deviazione standard
y2 = phi2*theta2;

% antitrasformo phi2*theta2
wpe2 = exp(phi2*theta2)./(1 + exp(phi2*theta2)); % wpe2 = wp estimated
epsilon2 = wp - wpe2;
ssr2 = epsilon2' * epsilon2;
rmse2 = sqrt(ssr2/length(wp));

figure(5)
scatter(ws, wp, 'x');
title('Modello quadratico: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot w_s^2 $', 'Interpreter', 'latex')
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe2, '.', 'red')

%GOF modello quadratico 
thetaGOF = lscov([ ones(length(y2), 1), wpl], y2);

figure;
scatter(wpl, y2, '.', 'MarkerFaceAlpha',.55,'MarkerEdgeAlpha',.55);
grid on;
hold on;
plot([-3, 3], [-3,3], 'LineWidth', 2);
plot([-3, 3], thetaGOF(1) + thetaGOF(2)*[-3,3], 'LineWidth', 2);
axis([-3, 3, -3, 3]);
title('Goodness of fit for Model: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot w_s^2 $ ', 'Interpreter', 'latex');
xlabel('Actual Power [kW]', "Interpreter", 'latex');
ylabel('Estimated Power [kW]', "Interpreter", 'latex');
legend("Data vs. Estimates", "$45^{\circ}$ line", "Regression Line", "Interpreter", 'latex');