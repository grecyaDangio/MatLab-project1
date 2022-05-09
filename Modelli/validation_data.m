close;  
clc;
clear all; 

test_data = readtable('../DataSet/test.csv');

wp1_validation= test_data.wp1;
ws_validation= test_data.ws;
wd_validation= test_data.wd;
hors_validation= test_data.hors;

wp1= wp1_validation(1:2811,1);
ws= ws_validation(1:2811,1);
wd= wd_validation(1:2811,1);
hors= hors_validation(1:2811,1);

val_data = [wp1 ws wd hors]; 