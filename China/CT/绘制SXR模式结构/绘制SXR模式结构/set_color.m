% 该函数用于为高速相机图像设置colorbar
% 韩玉箫 2024年04月24日

function [color_matrix]=set_color(figure_in,color_map,intensity_range)

%下面获取强度范围
intensity_max=intensity_range(2);
intensity_min=intensity_range(1);

%下面获取强度向量
figure0_list=figure_in;

%下面将强度限制在强度范围内
figure_list=figure0_list;
figure_list(figure_list<intensity_min)=intensity_min;
figure_list(figure_list>intensity_max)=intensity_max;

%下面读取colormap
R_colormap=color_map(:,1);
G_colormap=color_map(:,2);
B_colormap=color_map(:,3);
position_colormap=linspace(intensity_min,intensity_max,length(R_colormap))';

%下面插值获取图像强度处的颜色
R_list=interp1(position_colormap,R_colormap,figure_list,'spline');
G_list=interp1(position_colormap,G_colormap,figure_list,'spline');
B_list=interp1(position_colormap,B_colormap,figure_list,'spline');

color_matrix=cat(3,R_list,G_list,B_list);

end