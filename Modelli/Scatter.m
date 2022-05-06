clear;  
close;  
clc;
test = readtable('train.csv');

%% scatter plot 
log_wp1 = vpa(log(test.wp1 ./ (1-test.wp1)));


figure(1)
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


%% prova grafico della direzione del vento con aggiunta del centro (pallino rosso)
wd=deg2rad(test.wd);
z=test.ws.*exp(i.*wd);
figure(6)
plot(z,'x')
title('Grafico direzione velocita')
xlabel('Est                                        Ovest')
ylabel('Sud                                        Nord')
hold on 
scatter(0,0, 'r', 'Linewidth', 5)

% scatter tridimensionale della potenza-direzione e velocità del vento
figure(5)
plot3(real(z), imag(z), log_wp1, 'x')
xlabel('ReVelocità-Direzione')
ylabel('ImVelocità-Direzione')
zlabel('Potenza(Wp1)')