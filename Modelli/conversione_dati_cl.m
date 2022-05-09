% load('clean_dataset.mat')
% csvwrite('clean_dataset.csv', cl_dataset)
% 
% load('logit_data.mat')
% csvwrite('clean_dataset_logit.csv', train_data)

train= load ('logit_data.mat');
wp1= train(:,1);
ws=train(:,2);


