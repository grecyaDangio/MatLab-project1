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
title('Modello quadratico: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot w_s^2 $', 'Interpreter', 'latex')
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
title('Modello cubico: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot w_s^2 + t_4 \cdot w_s^3 $', 'Interpreter', 'latex')
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
title('Modello trigonometrico: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot \cos(w_d) + t_4 \sin(wd) $', 'Interpreter', 'latex')
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



%grid on
% az = 0;
% el = 0;
% view([az,el])
% degStep = 1;
% deltaT = 0.01;
% fCount = 50;
% f = getframe(gcf);
% [im,map] = rgb2ind(f.cdata,256,'nodither');
% im(1,1,1,fCount) = 0;
% k = 1;
% 
% for i = 0:degStep:360
%   az = i;
%   view([az,el])
%   f = getframe(gcf);
%   im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
%   k = k + 1;
% end


% imwrite(im,map,'Animation.gif','DelayTime',deltaT,'LoopCount',inf)

%% modello trigonometrico con armoniche del 2 ordine

phit2 = [ones(length(wpl), 1), ws, cos(wd), sin(wd), cos(2*wd), sin(2*wd)];
[thetat2, devt2] = lscov(phit2, wpl);  % devt = deviazione standard

% antitrasformo phit * thetat
wpet2 = exp(phit2*thetat2)./(1 + exp(phit2*thetat2)); % wpet = wp estimated
epsilont2 = wp - wpet2;
ssrt2 = epsilont2' * epsilont2;
rmset2 = sqrt(ssrt2/length(wp));
figure(8)

scatter3(ws, wd, wp, 'x');
title('Modello con armoniche 1° e 2° ordine: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot \cos(w_d) + t_4 \sin(wd) + t_5 \cdot \cos(2 \cdot w_d) + t_6 \sin(2 \cot wd) $', 'Interpreter', 'latex')
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

%% modello trigonometrico con armoniche del primo 1/2 ordine

phit12 = [ones(length(wpl), 1), ws, cos(wd), sin(wd), cos(wd/2), sin(wd/2)];
[thetat12, devt12] = lscov(phit12, wpl);  % devt = deviazione standard

% antitrasformo phit * thetat
wpet12 = exp(phit12*thetat12)./(1 + exp(phit12*thetat12)); % wpet = wp estimated
epsilont12 = wp - wpet12;
ssrt12 = epsilont12' * epsilont12;
rmset12 = sqrt(ssrt12/length(wp));
figure(8)

scatter3(ws, wd, wp, 'x');
title('Modello con armoniche 1° e 1/2° ordine: $P(w_s) = t_1 + t_2 \cdot w_s + t_3 \cdot \cos(w_d) + t_4 \sin(wd) + t_5 \cdot \cos(\frac{w_d}{2}) + t_6 \sin(\frac{wd}{2}) $', 'Interpreter', 'latex')
xlabel('ws');
ylabel('wd');
zlabel('wp');

% hold on
% scatter3(ws, wd, wpet, '.', 'green')

ws_grid12 = linspace (0, 14,100)';
wd_grid12 = linspace(0, 6, 100)';
[ws_mat12, wd_mat12] = meshgrid(ws_grid12, wd_grid12);
ws_vec12 = ws_mat12(:);
wd_vec12 = wd_mat12(:);
phi_grid12 = [ones(length(ws_vec12), 1), ws_vec12, cos(wd_vec12), sin(wd_vec12), cos(wd_vec12/2), sin(wd_vec12/2)];
wp_vec_logit12 = phi_grid12 * thetat12;
wp_vec12 = exp(wp_vec_logit12)./(1 + exp(wp_vec_logit12)); 
wp_mat12 = reshape(wp_vec12, size(wd_mat12));
hold on
mesh(ws_mat12, wd_mat12, wp_mat12);

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
title('Modello trigonometrico con armoniche fino al 6 ordine (solo coseni)')
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

%% Modello fisico

%stima LS con dati trasformati
phith = 1/2.*ws.^3;
[rA, devrA] = lscov(phith,wp);

wpeth = rA .* ws.^3;
epsilonth = wp - wpeth;

rmseth = sqrt((epsilonth'*epsilonth)/length(wp)); %rmseth = rmse teorico
figure(10)
scatter(ws, wp, 'x');
xlabel('ws');
ylabel('wp');
hold on
scatter(ws, wpeth, '.', 'yellow')
title('modello teorico con identificazione lineare')
xlim([0 12])
ylim([0 1])

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










