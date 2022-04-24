clear;  
close;  
clc;
test = readtable('train.csv');

%% scatter plot con due variabili 
% 
figure(1)
log_wp1 = vpa(log(test.wp1 ./ (1-test.wp1)));
title('velocita del vento VS previsione oraria della velocita')
scatter(test.ws,test.wp1,'x','b');

figure(2)
scatter(test.ws,log_wp1,'x','b');
title('velocita del vento VS previsione oraria della velocita logit')
xlabel('ws');  
ylabel('wp1')


figure(3)
scatter(test.wd,log_wp1,'x','r');
title('velocita del vento VS previsione oraria della direzione del vento')
ylabel('wp1')
xlabel('wd')

figure(4)
scatter(test.hors,log_wp1,'x','g');
title('velocità del vento VS Orizzonte temporale della previsione di velocità e direzione del vento a partire dalla mezzanotte')
ylabel('wp1')
xlabel('hors')

% figure(5)
% plot3(real(test.ws),imag(test.ws),log_wp1,'o')
% grid on
% xlabel 'wind speed'
% ylabel 'wind directions'
% zlabel 'power'

%% prova grafico del vento 
wd=deg2rad(test.wd);
z=test.ws.*exp(i.*wd);
figure(6)
plot(z,'x')
title('Grafico direzione velocita')
xlabel('Est                                        Ovest')
ylabel('Sud                                        Nord')
hold on 
scatter(0,0, 'r', 'Linewidth', 5)

% scatter a tre dimensioni 
figure(5)
plot3(real(z), imag(z), log_wp1, 'x')
xlabel('ReVelocità-Direzione')
ylabel('ImVelocità-Direzione')
zlabel('Potenza(Wp1)')


%% prova di stima 

%prova con modello lineare 
cast_log_wp1=(cast(log_wp1, "double"));
N=28116;


phi1 =[ones(length(test.ws),1), test.ws];
[theta1]=(phi1\log_wp1);  
rendimento_ls_affine=phi1*theta1;
residui_ls_affine= test.wd-rendimento_ls_affine ;
SSR1= (residui_ls_affine)'*residui_ls_affine;
RMSE1=sqrt(SSR1/N);

%modello quadratico

% phi2 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2];
% [theta2]=lscov(phi2, cast_log_wp1);
% rendimento_ls_affine2=phi2*theta2;
% residui_ls_affine2= log_wp1-rendimento_ls_affine2 ;
% SSR2= (residui_ls_affine2)'*residui_ls_affine2;
% RMSE2=sqrt(SSR2/N);
% 
% 
% %prova con modello cubico 
% phi3 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2, test.ws.^3,test.wd.^3, ...
% test.ws.*test.wd, (test.ws.^2).*test.wd, (test.wd.^2).*test.ws];
% [theta3]=lscov(phi3, cast_log_wp1);
% rendimento_ls_affine3=phi3*theta3;
% residui_ls_affine3= log_wp1-rendimento_ls_affine3 ;
% SSR3= (residui_ls_affine3)'*residui_ls_affine3;
% RMSE3=sqrt(SSR3/N);
% 
% 
% %prova modello con coseno
% 
% phi4 =[ones(length(test.ws),1), test.ws,abs(cos(test.wd))];
% [theta4]=lscov(phi4,cast_log_wp1);
% rendimento_ls_affine4=phi4*theta4;
% residui_ls_affine4= log_wp1-rendimento_ls_affine4 ;
% SSR4= (residui_ls_affine4)'*residui_ls_affine4;
% RMSE4=sqrt(SSR4/N);



