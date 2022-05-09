clear all;  
close;  
clc;
train = readtable('../DataSet/train.csv');


%clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
%wl= without logit 
%no vpa
cl_wp= train.wp1(train.wp1 > 0 & train.wp1  ~= 1);
cl_ws= train.ws(train.wp1 > 0 & train.wp1  ~= 1);
cl_wd= train.wd(train.wp1 > 0 & train.wp1  ~= 1);
cl_wh= train.hors(train.wp1 > 0 & train.wp1  ~= 1);

train_data_cl_1 = [cl_wp cl_ws cl_wd cl_wh];

logit_wp1 = (log(cl_wp ./ (1-cl_wp)));
logit_wp = vpa(log(train.wp1 ./ (1-train.wp1)));   %logit con dati sporchi

wp= train.wp1(logit_wp1 > -4 & logit_wp1<4 );
ws= train.ws(logit_wp1 > -4 & logit_wp1<4 );
wd= train.wd(logit_wp1 > -4 & logit_wp1<4 );
wh= train.hors(logit_wp1 > -4 & logit_wp1<4);

train_data_clear = [wp ws wd wh];

figure(1)
scatter(cl_ws,logit_wp1,'.', 'r');
title('Dati puliti togliendo solo 0 e 1')

% 
figure(2)
plot(ws, wp, '.')
grid on
title('Dati puliti completi utilizzando la funzione logit')
xlabel('velocità del vento (ws)')
ylabel('potenza(wp1)')
% 
