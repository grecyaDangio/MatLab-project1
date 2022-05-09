clear;  
close;  
clc;
test = readtable('../DataSet/train.csv');
%clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
%wl= without logit 
%no vpa

cl_wp_wl= test.wp1(test.wp1 > 0 & test.wp1  ~= 1);
cl_ws_wl= test.ws(test.wp1 > 0 & test.wp1  ~= 1);
% cl_wd_wl= test.wd(test.wp1 > 0 & test.wp1  ~= 1);
% cl_wh_wl= test.hors(test.wp1 > 0 & test.wp1  ~= 1);

logit_wp1 = (log(cl_wp_wl ./ (1-cl_wp_wl)));
logit_wp = vpa(log(test.wp1 ./ (1-test.wp1)));   %logit con dati sporchi

cl_wp= logit_wp1( logit_wp1 > -3.5 & logit_wp1<3 );
cl_ws= test.ws(logit_wp1 > -3.5 & logit_wp1<3);
% cl_wd= test.wd(logit_wp1 > -3.5 & logit_wp1<3);
% cl_wh= test.hors(logit_wp1 > -3.5 & logit_wp1<3);

cl_dataset = [cl_wp cl_ws];

figure(1)
scatter(cl_ws_wl,logit_wp1,'.', 'r');
title('Dati puliti 1 con logit')



% %figura 1
% 
% figure(1)
% scatter(test.ws,logit_wp,'x','b');
% title('velocita del vento VS potenza (logit)')
% xlabel('windspeed (ws)');  
% ylabel('wind power (wp1)')
% 
% figure(2)
% plot(cl_ws, cl_wp, '.')
% grid on
% title('Dati puliti e con logit')
% xlabel('velocità del vento (ws)')
% ylabel('potenza(wp1')
% 
% %figura 3
% figure(3)
% plot(cl_ws_wl, logit_wpl, '.')
% grid on
% title('Dati puliti senza logit')
% xlabel('velocità del vento (ws)')
% ylabel('potenza(wp1')
% 
% 
% 
% 
% 
