clc
close all
test=readtable('train.csv')
%% scatter plot con due variabili 

figure(1)
scatter(test.ws,test.wp1,'x','b');
title('velocita del vento VS previsione oraria della velocita')
ylabel('wp1')
xlabel('ws')



figure(2)
scatter(test.wd,test.wp1,'x','r');
title('velocita del vento VS previsione oraria della direzione del vento')
ylabel('wp1')
xlabel('wd')


figure(3)
scatter(test.hors,test.wp1,'x','g');
title('velocità del vento VS Orizzonte temporale della previsione di velocità e direzione del vento a partire dalla mezzanotte')
ylabel('wp1')
xlabel('hors')


% prova di stima 

% phi1 =[ones(length(test.ws),1), test.ws];
% [theta1,std1]=lscov(phi1, test.wp1);
% rendimento_ls_affine=phi1*theta1;
% residui_ls_affine= test.wp1-rendimento_ls_affine ;
% SSR1= (residui_ls_affine)'*residui_ls_affine;




%% prova grafico del vento 
wd=deg2rad(test.wd)
z=test.ws.*exp(i.*wd)
figure(4)
plot(z,'x')
title('Grafico direzione velocita')
xlabel('Est                                        Ovest')
ylabel('Sud                                        Nord')
hold on 
scatter(0,0, 'r', 'Linewidth', 5)


