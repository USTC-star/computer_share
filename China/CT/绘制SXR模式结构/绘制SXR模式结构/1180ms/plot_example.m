clear;clc;close all;
load Tomo_6608_SXR.mat

figure(1);hold on;
itime=14;
pcolor(RR,ZZ,reshape(E_tomo(:,itime),size(RR)));% emissity
plot(R_wall,Z_wall,'w-','LineWidth',1.0);
shading interp;axis equal;axis tight;
title(['Time = ',num2str(T_tomo(itime)),' ms']);


figure(3);hold on;box on;% Mode_1_U
itime=1:11000;% Time in [T_tomo(1), T_tomo(11000)]
[U,S,V]=svd(E_tomo(:,itime));% svd
EE=reshape(U(:,3),size(RR));EE(~Inner)=nan;% topos #3
pcolor(RR*1000,ZZ*1000,EE);shading interp;
colormap(jet);axis equal;axis tight;
plot(R_wall*1000,Z_wall*1000,'k','LineWidth',1.0);
hold on;

figure(2);hold on;box on;% Mode_1_V
plot(T_tomo(itime),V(:,3));% topos #3