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

% antitrasformo phi*theta
wpe = exp(phi*theta)./(1 + exp(phi*theta)); % wpe = wp estimated. tolgo la logit
epsilon = wp - wpe;
ssr = epsilon' * epsilon;
rmse = sqrt(ssr/length(wp));


figure(4)
scatter(ws, wp, 'x');
title('modello lineare')
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe, '.' ,'yellow')


%% modello quadratico
% y = t1 + t2*ws +t3*ws^2
% wp = t1 + t2*ws
phi2 = [ones(length(wpl), 1), ws, ws.^2];
[theta2, dev2] = lscov(phi2, wpl);  % dev = deviazione standard

% antitrasformo phi2*theta2
wpe2 = exp(phi2*theta2)./(1 + exp(phi2*theta2)); % wpe2 = wp estimated
epsilon2 = wp - wpe2;
ssr2 = epsilon2' * epsilon2;
rmse2 = sqrt(ssr2/length(wp));

figure(5)
scatter(ws, wp, 'x');
title('modello quadratico')
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe2, '.', 'red')


%% modello cubico
% y = t1 + t2*ws +t3*ws^2 + t4*ws^3
% wp = t1 + t2*ws
phi3 = [ones(length(wpl), 1), ws, ws.^2, ws.^3];
[theta3, dev3] = lscov(phi3, wpl);  % dev = deviazione standard

% antitrasformo phi3*theta3
wpe3 = exp(phi3*theta3)./(1 + exp(phi3*theta3)); % wpe3 = wp estimated
epsilon3 = wp - wpe3;
ssr3 = epsilon3' * epsilon3;
rmse3 = sqrt(ssr3/length(wp));
figure(6)
scatter(ws, wp, 'x');
title('modello cubico')
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpe3, '.', 'black')


%% modello trigonometrico
% y = t1 + t2*ws +t3*cos(wd) + t4*sin(wd)

phit = [ones(length(wpl), 1), ws, cos(wd), sin(wd)];
[thetat, devt] = lscov(phit, wpl);  % devt = deviazione standard

% antitrasformo phit*thetat
wpet = exp(phit*thetat)./(1 + exp(phit*thetat)); % wpet = wp estimated
epsilont = wp - wpet;
ssrt = epsilont' * epsilont;
rmset = sqrt(ssrt/length(wp));
figure(7)
scatter3(ws, wd, wp, 'x');
title('modello trigonometrico')
xlabel('ws');
ylabel('wd');
zlabel('wp');

ws_grid = linspace (0, 14,100)';
wd_grid = linspace(0, 6, 100)';
[ws_mat, wd_mat] = meshgrid(ws_grid, wd_grid);
ws_vec = ws_mat(:);
wd_vec = wd_mat(:);
phi_grid = [ones(length(ws_vec), 1), ws_vec, cos(wd_vec), sin(wd_vec)];
wp_vec_logit = phi_grid * thetat;
wp_vec = exp(wp_vec_logit)./(1 + exp(wp_vec_logit)); 
wp_mat = reshape(wp_vec, size(wd_mat));
hold on
mesh(ws_mat, wd_mat, wp_mat);

%% modello trigonometrico con armoniche del 2 ordine

phit2 = [ones(length(wpl), 1), ws, cos(wd), sin(wd), cos(2*wd), sin(2*wd)];
[thetat2, devt2] = lscov(phit2, wpl);  % devt = deviazione standard

% antitrasformo phit*thetat
wpet2 = exp(phit2*thetat2)./(1 + exp(phit2*thetat2)); % wpet = wp estimated
epsilont2 = wp - wpet2;
ssrt2 = epsilont2' * epsilont2;
rmset2 = sqrt(ssrt2/length(wp));
figure(8)

scatter3(ws, wd, wp, 'x');
title('modello trigonometrico con armoniche del 2 ordine (sin e cos)')
xlabel('ws');
ylabel('wd');
zlabel('wp');

% hold on
% scatter3(ws, wd, wpet, '.', 'green')

ws_grid2 = linspace (0, 14,100)';
wd_grid2 = linspace(0, 6, 100)';
[ws_mat2, wd_mat2] = meshgrid(ws_grid2, wd_grid2);
ws_vec2 = ws_mat2(:);
wd_vec2 = wd_mat2(:);
phi_grid2 = [ones(length(ws_vec2), 1), ws_vec2, cos(wd_vec2), sin(wd_vec2), cos(2*wd_vec2), sin(2*wd_vec2)];
wp_vec_logit2 = phi_grid2 * thetat2;
wp_vec2 = exp(wp_vec_logit2)./(1 + exp(wp_vec_logit2)); 
wp_mat2 = reshape(wp_vec2, size(wd_mat2));
hold on
mesh(ws_mat2, wd_mat2, wp_mat2);


%% modello trigonometrico con armoniche fino al 6 ordine

phit3 = [ones(length(wpl), 1), ws, cos(wd), cos(2*wd), cos(3*wd), cos(4*wd), cos(5*wd), cos(6*wd)];
[thetat3, devt3] = lscov(phit3, wpl);  % devt = deviazione standard

% antitrasformo phit*thetat
wpet3 = exp(phit3*thetat3)./(1 + exp(phit3*thetat3)); % wpet = wp estimated
epsilont3 = wp - wpet3;
ssrt3 = epsilont3' * epsilont3;
rmset3 = sqrt(ssrt3/length(wp));
figure(9)

scatter3(ws, wd, wp, 'x');
title('modello trigonometrico con armoniche fino al 6 ordine (solo coseni)')
xlabel('ws');
ylabel('wd');
zlabel('wp');

% hold on
% scatter3(ws, wd, wpet, '.', 'green')

ws_grid3 = linspace (0, 14,100)';
wd_grid3 = linspace(0, 6, 100)';
[ws_mat3, wd_mat3] = meshgrid(ws_grid3, wd_grid3);
ws_vec3 = ws_mat3(:);
wd_vec3 = wd_mat3(:);
phi_grid3 = [ones(length(ws_vec3), 1), ws_vec3, cos(wd_vec3), cos(2*wd_vec3), cos(3*wd_vec3), cos(4*wd_vec3), cos(5*wd_vec3), cos(6*wd_vec3)];
wp_vec_logit3 = phi_grid3 * thetat3;
wp_vec3 = exp(wp_vec_logit3)./(1 + exp(wp_vec_logit3)); 
wp_mat3 = reshape(wp_vec3, size(wd_mat3));
hold on
mesh(ws_mat3, wd_mat3, wp_mat3);

%% Modello teorico
% y = ws; x = wp;
%chiedere perchè il parametro stimato viene 0.0028 e non circa 2500*pi*1.225
%perchè rmse sono molto differenti fra identificazione e validazione
%(0.5*(rA*ws.^3)); %my_fun modello teorico @ parametri che si passano

%stima LS con dati trasformati
phith = ws.^3;
[rA, devrA] = lscov(phith,wpl);
%antitrasformo
wpeth = exp(phit*thetat)./(1 + exp(phit*thetat)); 
epsilonth = wp - wpeth;
rmseth = sqrt((epsilonth'*epsilonth)/length(wp)); %rmseth = rmse teorico
figure(10)
scatter(ws, wp, 'x');
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpeth, '.', 'yellow')
title('modello teorico con identificazione lineare')


%% rappresentazione dei modelli con logit

figure(11)
scatter(ws, wpl, 'x');
title('scatter dati puliti')
xlabel('ws filtrato');
ylabel('logit wp filtrato');
hold on
scatter(ws, phi*theta, '.', 'yellow');
scatter(ws, phi2*theta2, '.', 'green');
scatter(ws, phi3*theta3, '.', 'red');
scatter(ws, phith*rA, '.', 'black');
legend("Scatter dati", "Modello lineare","Modello quadratico", "Modello cubico", "Modello teorico", "Interpreter", 'latex');
%%
% confrontando rmse (del modello lineare) e rmset (del modello teorico)
% essendo dello stesso ordine vince il modello lineare %%%%%%%%%%%(non è meglio quello trigonometrico che tiene in considerazione un altro parametro e riduce seppur di poco ssr)

%% commento finale fase di identificazione
% come si può facilmente notare, RMSE in tutti i casi non varia di molto.
% Personalmente ritengo che il modello lineare sia quello più efficiente in
% fase di identificazione poichè negli altri modelli, dato l'aumento
% considerevole del numero dei parametri non ottengo miglioramenti
% apprezzabili.
% (esempio, rmse non cambia ordine di grandezza).

