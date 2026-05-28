
clear


%% 下面读取真空室内壁数据
load('Limiter20221017.mat');
r_limiter=1000*Limiter.r;
z_limiter=1000*Limiter.z;


%% 下面导入EFIT磁面数据
device='HL-3';
EFIT_root_path=['F:\26、诊断数据\',device,'\EFIT\'];%EFIT数据根目录
shot=4173;%炮号
time=774;%EFIT数据时间点，单位ms
flux_value=-1:0.05:3;%要展示的磁通面的通量值

EFIT_parameters=struct('EFIT_root_path',EFIT_root_path,......
                       'device',device,...
                       'shot',shot,...
                       'time',time);

%下面读取磁场数据
magnetic_data=get_B_EFIT.read_EFIT_data(EFIT_parameters);

%下面提取磁通面数据
r=magnetic_data.r;
z=magnetic_data.z;
R=magnetic_data.R;
Z=magnetic_data.Z;
psirzp=magnetic_data.psirzp;

%下面提取最后闭合磁面数据
LCFS_matrix=contourc(r,z,psirzp,[0.95,0.95]);
LCFS_R=LCFS_matrix(1,2:end);
LCFS_Z=LCFS_matrix(2,2:end);

nan_position=LCFS_R<1100 | LCFS_Z<-1000 | LCFS_Z>1000;
LCFS_R(nan_position)=[];
LCFS_Z(nan_position)=[];

%下面提取真空室内壁以内的磁通面数据
[in,on]=inpolygon(R(:),Z(:),r_limiter,z_limiter);
limiter_area=reshape(in | on,size(R));
psirzp(~limiter_area)=nan;


%% 下面导入SXR反演数据
load([pwd,'\1180ms\Tomo_6608_SXR.mat']);
RR=1000*RR;
ZZ=1000*ZZ;
itime=1:11000;% Time in [T_tomo(1), T_tomo(11000)]
[U,S,V]=svd(E_tomo(:,itime));% svd
EE=reshape(U(:,3),size(RR));

%下面对数据插值
SXR_interp=griddedInterpolant(RR,ZZ,EE);
RR_interp=1100:2:2442.3;
ZZ_interp=-1384.5:2:1244.9;
[RR_matrix,ZZ_matrix]=ndgrid(RR_interp,ZZ_interp);
EE_interp=SXR_interp(RR_matrix,ZZ_matrix);

%下面定位LCFS之外的数据点位置
[in,on]=inpolygon(RR_matrix(:),ZZ_matrix(:),LCFS_R,LCFS_Z);
draw_area=reshape(in | on,size(RR_matrix));

%下面将LCFS之外的数据点清空
EE_interp(~draw_area)=nan;

%下面设置颜色映射
color_map=jet;
intensity_range=[min(EE_interp,[],'all','omitmissing'),max(EE_interp,[],'all','omitmissing')];
% intensity_range=[-1,1];
color_matrix=set_color(EE_interp,color_map,intensity_range);


%% 下面绘图
%下面创建图窗
fig=figure(3);
set(fig,'color','w','Position',[0,0,600,1000]);%窗口背景颜色
font_size=15;

%下面绘制SXR反演的模式结构
ax=axes;
SXR_mode=surf(ax,RR_matrix,ZZ_matrix,-1*ones(size(EE_interp)),color_matrix);
SXR_mode.EdgeColor='none';
ax.DataAspectRatioMode='manual';
ax.DataAspectRatio=[1,1,10^(-3)];
ax.View=[0,90];
hold on;
box on;
axis equal;
axis tight;
grid off;
set(gca,'FontSize',font_size,'FontWeight','bold','linewidth',3);
xlabel('\itR \rm(mm)','FontSize',font_size,'FontWeight','bold');
ylabel('\itZ \rm(mm)','FontSize',font_size,'FontWeight','bold');
xlim([1050,2700]);
ylim([min(z_limiter,[],'all')-50,max(z_limiter,[],'all')+50]);

%下面绘制磁通面曲线
contour(R,Z,psirzp,flux_value,'k--','linewidth',0.5);

%下面绘制真空室内壁
plot(r_limiter,z_limiter,'k','LineWidth',3);









