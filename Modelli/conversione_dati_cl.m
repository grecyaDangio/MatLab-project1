
clear all;

% load('clean_dataset.mat')
% csvwrite('clean_dataset.csv', cl_dataset)
% 
% load('logit_data.mat')
% csvwrite('clean_dataset_logit.csv', train_data)

% cl_data= load ('../DataSet/validation_data.mat');
% csvwrite('validation_data.csv', val_data)
% 


validation_data = readtable('../DataSet/validation_data.csv');

validation_data.Properties.VariableNames(1:4) = {'wp1','ws','wd','hors'};
