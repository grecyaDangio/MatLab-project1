clc; clear; close all;

test = readtable ('../DataSet/train.csv');
wp = test.wp1;
ws = test.ws;

%% cancello 1 e 0
ws = ws(wp ~= 0 & wp ~= 1);
wp = wp(wp ~= 0 & wp ~= 1);

figure(1)
scatter(ws, wp, 'x');
title('scatter dati senza 0 e 1') % tolgo gli 0 e gli 1 per far funzionare la logit
xlabel('ws');
ylabel('wp');

%% logit
wpl = log(wp./(1-wp)); % faccio la logit dei dati
figure(2)
scatter(ws, wpl, 'x');
title('scatter dati trasformati')
xlabel('ws');
ylabel('logit wp');

%% filtraggio righe
ws = ws(wpl > -4 & wpl < 4);
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

% antitrasformo phi*theta
wpe = exp(phi*theta)./(1 + exp(phi*theta)); % wpe = wp estimated
epsilon = wp - wpe;
ssr = epsilon' * epsilon;
rmse = sqrt(ssr/length(wp));
plot(ws, phi*theta);

figure(4)
scatter(ws, wp, 'x');
title('modello lineare')
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe, 'yellow')

%% Modello teorico
% y = ws; x = wp;
my_fun = @(rA, ws) (0.5*(rA*ws.^3));
initials = pi * 50^2 * 1.225;
[rA, residuals] = nlinfit(ws, wp, my_fun, initials);
wpt = my_fun(rA, ws); % wpt = wp teorica

rmset = sqrt((residuals'*residuals)/length(wpt)); %rmset = rmse teorico
figure(5)
scatter(ws, wp, 'x');
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpt, 'yellow')
title('modello teorico con identificazione non lineare')
ylim([0 1])
% raggio compreso fra 10 e 85 metri, ipotizzo un raggio di 50 metri

%1.225 kg/m^3



%%
% confrontando rmse (del modello lineare) e rmset (del modello teorico)
% vince il modello lineare
