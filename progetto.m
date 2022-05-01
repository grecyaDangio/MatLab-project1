clear;  
close;  
clc;
test = readtable('train.csv');


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



%modello quadratico

phi2 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2];
[theta2]=lscov(phi2, test.wp1);
rendimento_ls_affine2=phi2*theta2;
residui_ls_affine2= test.wp1-rendimento_ls_affine2 ;
SSR2= (residui_ls_affine2)'*residui_ls_affine2;
RMSE2=sqrt(SSR2/N);

% %prova con modello cubico 

phi3 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2, test.ws.^3,test.wd.^3, ...
test.ws.*test.wd, (test.ws.^2).*test.wd, (test.wd.^2).*test.ws];
[theta3]=lscov(phi3, test.wp1);
rendimento_ls_affine3=phi3*theta3;
residui_ls_affine3= test.wp1-rendimento_ls_affine3 ;
SSR3= (residui_ls_affine3)'*residui_ls_affine3;
RMSE3=sqrt(SSR3/N);


% 
% phi2 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2];
% [theta2]=lscov(phi2, cast_log_wp1);
% rendimento_ls_affine2=phi2*theta2;
% residui_ls_affine2= log_wp1-rendimento_ls_affine2 ;
% SSR2= (residui_ls_affine2)'*residui_ls_affine2;
% RMSE2=sqrt(SSR2/N);
% 
% 
% phi3 =[ones(length(test.ws),1), test.ws,test.wd, test.ws.^2,test.wd.^2, test.ws.^3,test.wd.^3, ...
% test.ws.*test.wd, (test.ws.^2).*test.wd, (test.wd.^2).*test.ws];
% [theta3]=lscov(phi3, cast_log_wp1);
% rendimento_ls_affine3=phi3*theta3;
% residui_ls_affine3= log_wp1-rendimento_ls_affine3 ;
% SSR3= (residui_ls_affine3)'*residui_ls_affine3;
% RMSE3=sqrt(SSR3/N);
% 
% 
% %prova modello con coseno
% 
% phi4 =[ones(length(test.ws),1), test.ws,abs(cos(test.wd))];
% [theta4]=lscov(phi4,cast_log_wp1);
% rendimento_ls_affine4=phi4*theta4;
% residui_ls_affine4= log_wp1-rendimento_ls_affine4 ;
% SSR4= (residui_ls_affine4)'*residui_ls_affine4;
% RMSE4=sqrt(SSR4/N);



