% 该类用于从EFIT数据中计算空间中的磁场
% 韩玉箫 2023年03月21日

classdef get_B_EFIT
    
    methods (Static=true)
        
        
       %% 该函数用于从EFIT数据文件中读取磁场数据
        function [magnetic_data]=read_EFIT_data(EFIT_parameters)
            
            %下面读取EFIT参数
            EFIT_root_path=EFIT_parameters.EFIT_root_path;
            device=EFIT_parameters.device;
            shot=EFIT_parameters.shot;
            time=EFIT_parameters.time;

            %下面读取EFIT数据的时刻列表
            [t_EFIT_list]=get_EFIT_range([EFIT_root_path,'\',num2str(shot),'\',num2str(shot),'.txt']);

            %下面判断输入的时刻点数据是否存在
            t_exist=sum(t_EFIT_list==time);
            if t_exist>=1
            else
                [~,t_interest_loc]=min(abs(t_EFIT_list-time));
                time_read=t_EFIT_list(t_interest_loc(1));
                fprintf(['\n注意：当前选定的时刻点 t = ',num2str(time),' ms 无对应的EFIT数据，读取时刻点已自动调整为相距最近的 t = ',num2str(time_read),' ms ！\n\n']);
                EFIT_parameters.time=time_read;
                time=time_read;
            end

            %下面读取EFIT数据文件
            filename=[EFIT_root_path,'\',num2str(shot),'\g',num2str(shot,'%06d'),'.',num2str(time,'%05d')];
            fid=fopen(filename,'r');
            
            %下面从EFIT文件中读取数据
            sline=fgetl(fid);
            dum=sscanf(sline(1,49:length(sline)),'%d');
            nw=dum(2);
            nh=dum(3);
            
            dum=fscanf(fid,'%f',5);
            xdim=dum(1);
            zdim=dum(2);
            rgrid1=dum(4);
            zmid=dum(5);
            
            fscanf(fid,'%f',5);
            dum=fscanf(fid,'%f',5);
            ssimag =dum(2);
            
            dum=fscanf(fid,'%f',5);
            ssibry=dum(3);
            
            fpol=fscanf(fid,'%f',nw);
            
            fscanf(fid,'%f',3*nw);
            psirz=fscanf(fid,'%f',[nw,nh]);
            psizr=-psirz'*2*pi;
            
            fclose(fid);
            
            %下面从EFIT数据中计算极向磁场
            r=linspace(rgrid1,(rgrid1+xdim),nw)';
            z=linspace((zmid-zdim/2),(zmid+zdim/2),nh)';
            drefit=(r(end)-r(1))/(nw-1);
            dzefit=(z(end)-z(1))/(nh-1);
            
            [R,Z]=meshgrid(r,z);
            [dfdz,dfdr]=gradient(psizr,drefit,dzefit);
            B_R=-dfdr./R/(2*pi);
            B_Z=dfdz./R/(2*pi);
            
            %下面从EFIT数据中计算环向场
            Bt=fpol./r;
            
            %下面将长度单位从m调整为mm
            R=1000*R;
            Z=1000*Z;
            r=1000*r;
            z=1000*z;
            
            %下面对磁场进行插值
            F_B_R=griddedInterpolant(R',Z',B_R','spline');
            F_B_Z=griddedInterpolant(R',Z',B_Z','spline');
            F_Bt=griddedInterpolant(r,Bt);
            
            %下面从EFIT数据中计算磁通面数据
            psirzp=(psirz'-ssimag)/(ssibry-ssimag);
            
            %下面记录EFIT数据的信息
            EFIT_information=['Device=',device,'，Shot=',num2str(shot),'，Time=',num2str(time),'ms'];
            
            %下面将磁场数据存入结构体
            magnetic_data=struct('EFIT_information',EFIT_information,...
                                 'B_R',B_R,...
                                 'B_Z',B_Z,...
                                 'Bt',Bt,...
                                 'F_B_R',F_B_R,...
                                 'F_B_Z',F_B_Z,...
                                 'F_Bt',F_Bt,...
                                 'R',R,...
                                 'Z',Z,...
                                 'r',r,...
                                 'z',z,...
                                 'psirzp',psirzp);
                           
        end
        
        
       %% 该函数用于计算等离子体磁场
        function [B,B_norm,B0]=get_magnetic_field(location,SLIP_parameters,Simulate_parameters,mode)
            
            % Bt_direction表示纵场的方向，由于EFIT无法给出纵场方向，需要自行设置，正值代表顺时针，负值代表逆时针，0代表无纵场
            % mode的值为0时表示输入的坐标为装置坐标系的坐标，值不为0时表示输入的坐标为探针坐标系的坐标，需要先转换为装置坐标系坐标再求磁场
            
            %下面读取探针数据
            EFIT_parameters=Simulate_parameters.EFIT_parameters;
            Bt_direction=EFIT_parameters.Bt_direction;
            magnetic_data=Simulate_parameters.magnetic_data;

            attitude_parameters=SLIP_parameters.attitude_parameters;
            
            a_mid=attitude_parameters(1);
            a_mer=attitude_parameters(2);
            a_self=attitude_parameters(3);
            d_R=attitude_parameters(4);
            d_z=attitude_parameters(5);
            
            %下面载入EFIT磁场数据
            F_B_R=magnetic_data.F_B_R;
            F_B_Z=magnetic_data.F_B_Z;
            F_Bt=magnetic_data.F_Bt;
            
            %下面将探针坐标系中的坐标转换到装置坐标系
            if mode==0
            else
                d_base_point=attitude_parameters(6:8);
                direction=[a_mid+90,a_mer,a_self-90];
                d_actual_point=[0,d_R,d_z];
                location=points_transform_between_new_and_original_coordinate(location,...
                                                                              d_base_point,...
                                                                              direction,...
                                                                              d_actual_point,...
                                                                              0);
            end
            
            %下面计算该点处的大半径值和高度值
            R_points=vecnorm([location(:,1),location(:,2)],2,2);
            Z_points=location(:,3);
            
            %下面拟合得到该点处沿大半径方向和竖直方向的磁场模值
            B_R_points=F_B_R(R_points,Z_points);
            B_Z_points=F_B_Z(R_points,Z_points);
            
            %下面计算圆心指向该点的矢量的方向
            R0_vector=location./R_points;
            R0_vector(:,3)=0;
            
            %下面计算该点处的极向场矢量
            Bp=B_R_points.*R0_vector;
            Bp(:,3)=B_Z_points;
            
            %下面计算该点处的环向场模值
            Bt_norm=sign(Bt_direction)*F_Bt(R_points);
            
            %下面计算该点处对应的大环角度
            A=sign(location(:,1)).*(acos(location(:,2)./R_points)-pi*(1-sign(location(:,1))));
            
            %下面计算该点处的环向场
            Btx=Bt_norm.*cos(A);
            Bty=-Bt_norm.*sin(A);
            Btz=zeros(size(Btx));
            Bt=[Btx,Bty,Btz];
            
            %下面计算总磁场
            B=Bt+Bp;
            
            if mode==0
            else
                d_base_point_return=[0,0,0];
                direction_return=direction;
                d_actual_point_return=[0,0,0];
                B=points_transform_between_new_and_original_coordinate(B,...
                                                                       d_base_point_return,...
                                                                       direction_return,...
                                                                       d_actual_point_return,...
                                                                       1);
            end

            B_norm=vecnorm(B,2,2);
            B0=B./B_norm;
            
        end
        
        
    end

end

