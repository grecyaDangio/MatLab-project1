%% validazione dei modelli

%carico i dati di test

test = readtable('test.csv');
wp_test = test.wp1;
ws_test = test.ws;
wd_test = pi/180 * test.wd;

%%crossvalidazione

%matrici dei parametri dati validazione
phiV = [ones(length(wp_test), 1), ws_test];
phi2V = [ones(length(wp_test), 1), ws_test, ws_test.^2];
phi3V = [ones(length(wp_test), 1), ws_test, ws_test.^2, ws_test.^3];
phitV = [ones(length(wp_test), 1), ws_test, cos(wd_test), sin(wd_test)];
phit2V = [ones(length(wp_test), 1), ws_test, cos(wd_test), sin(wd_test), cos(2*wd_test), sin(2*wd_test)];
phit3V = [ones(length(wp_test), 1), ws_test, cos(wd_test), cos(2*wd_test), cos(3*wd_test), cos(4*wd_test), cos(5*wd_test), cos(6*wd_test)];
phithV = ws_test.^3;



%potenze stimate di validazione usando i phi_Val  e i theta_Id
wpeV = phiV * theta; 
wpeV2 = phi2V * theta2;
wpeV3 = phi3V * theta3;
wpeVt = phitV * thetat;
wpeVt2 = phit2V * thetat2;
wpeVt3 = phit3V * thetat3;
wpeVth = phithV * rA;


%residui fra previsione potenze e potenze di validazione
epsilonV = wp_test - wpeV;
epsilonV2 = wp_test - wpeV2;
epsilonV3 = wp_test - wpeV3;
epsilonVt = wp_test - wpeVt;
epsilonVt2 = wp_test - wpeVt2;
epsilonVt3 = wp_test - wpeVt3;
epsilonVth = wp_test - wpeVth;


%sono gli ssr
ssrV = epsilonV' * epsilonV;
ssrV2 = epsilonV2' * epsilonV2;
ssrV3 = epsilonV3' * epsilonV3;
ssrVt = epsilonVt' * epsilonVt;
ssrVt2 = epsilonVt2' * epsilonVt2;
ssrVt3 = epsilonVt3' * epsilonVt3;
ssrVth = epsilonVth' * epsilonVth;


%mrseV
msreV=sqrt(ssrV/length(wp_test));
msreV2=sqrt(ssrV2/length(wp_test));
msreV3=sqrt(ssrV3/length(wp_test));
msreVt=sqrt(ssrVt/length(wp_test));
msreVt2=sqrt(ssrVt2/length(wp_test));
msreVt3=sqrt(ssrVt3/length(wp_test));
msreVth=sqrt(ssrVth/length(wp_test));


% %% goodness of fit da fare
% %lungo y i dati stimati e lungo x i dati reali
% %ancora non funziona
% figure(9)
% plot([0 10],[0 10]) % retta a 45°
% hold on
% scatter(ws, phi*theta)
% scatter(ws, wp)


