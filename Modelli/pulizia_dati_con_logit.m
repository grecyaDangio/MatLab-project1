clear;  
close;  
clc;
test = readtable('../DataSet/train.csv');
%clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
%wl= without logit 

cl_wp_wl= test.wp1(test.wp1 > 0 & test.wp1  ~= 1);
cl_ws_wl= test.ws(test.wp1 > 0 & test.wp1  ~= 1);
cl_wd_wl= test.wd(test.wp1 > 0 & test.wp1  ~= 1);
cl_wh_wl= test.hors(test.wp1 > 0 & test.wp1  ~= 1);

logit_wp1 = vpa(log(cl_wp_wl ./ (1-cl_wp_wl)));

cl_wp= logit_wp1( logit_wp1 > -3.5 );
cl_ws= test.ws(logit_wp1 > -3.5);
cl_wd= test.wd(logit_wp1 > -3.5);
cl_wh= test.hors(logit_wp1 > -3.5);

cl_dataset = [cl_wp cl_ws cl_wd cl_wh];
