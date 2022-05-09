% load('clean_dataset.mat')
% csvwrite('clean_dataset.csv', cl_dataset)
% 
% load('logit_data.mat')
% csvwrite('clean_dataset_logit.csv', train_data)

cl_data= load ('../DataSet/dati_puliti_all.mat');
csvwrite('dati_puliti.csv', train_data_clear)


