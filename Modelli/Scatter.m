clear;  
close;  
clc;
train = readtable('../DataSet/train.csv');
test = readtable('../DataSet/train.csv');

%% scatter plot 
log_wp1 = vpa(log(train.wp1 ./ (1-train.wp1)));


figure(1)
title('velocità del vento VS potenza')
scatter(train.ws,train.wp1,'.','b');
xlabel('windspeed (ws)')
ylabel('wind power (wp1)')

figure(2)
scatter(train.ws,log_wp1,'x','b');
title('velocita del vento VS potenza (logit)')
xlabel('windspeed (ws)');  
ylabel('wind power (wp1)')


figure(3)
scatter(train.wd,log_wp1,'.','r');
title('potenza VS direzione del vento')
ylabel('wind power (wp1)')
xlabel('wind direction (wd)')

figure(4)
scatter(train.hors,log_wp1,'x','g');
title('Orizzonte temporale VS wind power')
ylabel('ore (hors)')
xlabel('wind power (wp1)')


%% prova grafico della direzione del vento con aggiunta del centro (pallino rosso)
wd=deg2rad(train.wd);
z=train.ws.*exp(i.*wd);
figure(6)
plot(z,'-->','Linewidth',1)
title('Grafico direzione velocita')
xlabel('Ovest                                                        Est')
ylabel('Sud                                        Nord')
hold on 
scatter(0,0, 'r', 'Linewidth', 5)

% scatter tridimensionale della potenza-direzione e velocità del vento
figure(5)
plot3(real(z), imag(z), log_wp1, 'x')
xlabel('ReVelocità-Direzione')
ylabel('ImVelocità-Direzione')
zlabel('Potenza(Wp1)')





