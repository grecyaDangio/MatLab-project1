close;  
clc;
clear all;  

test = readtable('../DataSet/test.csv');


%clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
%wl= without logit 
%no vpa
cl_wp= test.wp1(test.wp1 > 0 & test.wp1  ~= 1);
cl_ws= test.ws(test.wp1 > 0 & test.wp1  ~= 1);
cl_wd= test.wd(test.wp1 > 0 & test.wp1  ~= 1);
cl_wh= test.hors(test.wp1 > 0 & test.wp1  ~= 1);

test_data_cl_1 = [cl_wp cl_ws cl_wd cl_wh];

logit_wp1 = (log(cl_wp ./ (1-cl_wp)));
logit_wp = vpa(log(test.wp1 ./ (1-test.wp1)));   %logit con dati sporchi

wp= test.wp1(logit_wp1 > -4 & logit_wp1<4 );
ws= test.ws(logit_wp1 > -4 & logit_wp1<4 );
wd= test.wd(logit_wp1 > -4 & logit_wp1<4 );
wh= test.hors(logit_wp1 > -4 & logit_wp1<4);

test_data_clear = [wp ws wd wh];

figure(1)
scatter(cl_ws,logit_wp1,'.', 'r');
title('Dati puliti di test togliendo solo 0 e 1')

% 
figure(2)
plot(ws, wp, '.')
grid on
title('Dati puliti di test completi utilizzando la funzione logit')
xlabel('velocità del vento (ws)')
ylabel('potenza(wp1)')
% 


