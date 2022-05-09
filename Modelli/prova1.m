clear all;  
close all;  
clc;
test = readtable('../DataSet/train.csv');

% clean dataset
%pulizia dei dati, in quanto 0 e 1 provocavano NaN durante la ricerca del
%SSR
cl_wp= test.wp1(test.wp1 > 0 & test.wp1  ~= 1);
cl_ws= test.ws(test.wp1 > 0 & test.wp1  ~= 1);
cl_wd= test.wd(test.wp1 > 0 & test.wp1  ~= 1);
cl_wh= test.hors(test.wp1 > 0 & test.wp1  ~= 1);

cl_dataset = [cl_wp cl_ws cl_wd cl_wh];

log_wp1_cl = log(cl_wp ./ (1-cl_wp));


%% scatter plot con dati non puliti
log_wp1 = log(cl_wp ./ (1-cl_wp));



logit_wp1 = vpa(log(test.wp1 ./ (1-test.wp1)));
cast_log_wp1=(cast(logit_wp1, "double"));
N=28116;


%figura 
figure(1)
plot3(test.ws,test.wd,test.wp1, 'x')
grid on
xlabel('velcovità del vento (ws)')
ylabel('direzione del vento (wd')
zlabel('previsione oraria del vento (wp1)')


%% prova di stima senza linearizzazione con logit

%prova con modello lineare 
phi1 =[ones(length(test.ws),1), test.ws, test.wd];
[theta1]=(phi1\test.wp1);  
rendimento_ls_affine=phi1*theta1;
residui_ls_affine= test.wp1-rendimento_ls_affine ;
SSR1= (residui_ls_affine)'*residui_ls_affine;
RMSE1=sqrt(SSR1/N);

%%
ws_grid=linspace(0,50,5)';
wd_grid=linspace(0,300,10)';
[ws_grid_matrice, wd_grid_matrice]=meshgrid(ws_grid,wd_grid);

ws_vett= ws_grid_matrice(:);
wd_vett= wd_grid_matrice(:);  

phi1_grid= [ones(length(ws_vett),1), ws_vett, wd_vett];
wp1_vett1 = phi1_grid*theta1;

wp1_grid_matrice = reshape(wp1_vett1, size(ws_grid_matrice));

hold on
mesh(ws_grid_matrice, wd_grid_matrice,wp1_grid_matrice)



%% modello quadratico con logit clean data

phi2 =[ones(length(cl_ws),1), cl_ws, cl_wd, cl_ws.^2, cl_wd.^2];
[theta2]=lscov(phi2, log_wp1_cl);
rendimento_ls_affine2=phi2*theta2;
residui_ls_affine2= log_wp1_cl-rendimento_ls_affine2 ;
SSR2= (residui_ls_affine2)'*residui_ls_affine2;
RMSE2=sqrt(SSR2/N);

%% prova con modello cubico 

phi3 =[ones(length(cl_ws),1), cl_ws,cl_wd, cl_ws.^2,cl_wd.^2, cl_ws.^3,cl_wd.^3, ...
cl_ws.*cl_wd, (cl_ws.^2).*cl_wd, (cl_wd.^2).*cl_ws];
[theta3]=lscov(phi3, log_wp1_cl);
rendimento_ls_affine3=phi3*theta3;
residui_ls_affine3= log_wp1_cl-rendimento_ls_affine3 ;
SSR3= (residui_ls_affine3)'*residui_ls_affine3;
RMSE3=sqrt(SSR3/N);

% %figura 
figure(2)
plot3(cl_ws, cl_wd, cl_wp, 'x')
grid on
xlabel('velcovità del vento (ws)')
ylabel('direzione del vento (wd')
zlabel('previsione oraria del vento (wp1)')

ws_grid=linspace(0,1000,15)';
wd_grid=linspace(0,1000,360)';

[ws_grid_matrice, wd_grid_matrice]=meshgrid(ws_grid, wd_grid);

ws_vett= ws_grid_matrice(:);
wd_vett= wd_grid_matrice(:);


%phi2 =[ones(length(cl_ws),1), cl_ws, cl_wd, cl_ws.^2, cl_wd.^2];

phi2_grid= [ones(length(ws_vett),1), ws_vett, wd_vett, ws_vett.^2, wd_vett.^2];
wp1_vett2 = phi2_grid*theta2;

wp1_grid_matrice = reshape(wp1_vett2, size(ws_grid_matrice));

hold on
mesh(ws_grid_matrice,wd_grid_matrice, wp1_grid_matrice)
xlim([0 15])
ylim([0 360])
zlim([0 1])