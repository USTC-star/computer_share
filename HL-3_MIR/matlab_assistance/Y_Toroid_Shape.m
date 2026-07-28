%% 1. 输入 CODE V 界面中的参数
Rx = 10.000;       % X 半径
Ry = 20.000;       % Y 半径
K  = -1.5;        % 二次曲面常数 (Conic)
A  = 0.000;        % 4阶系数
B  = 0.0000;        % 6阶系数
C  = 0.0000;        % 8阶系数
D  = 0.000;        % 10阶系数

% 定义计算和可视化的口径范围 (例如：-100 到 100)
aperture_radius = 19.9; 
% [X, Y] = meshgrid(linspace(-aperture_radius, aperture_radius, 200));
Y=linspace(-aperture_radius, aperture_radius, 200);
%% 2. 计算 Y-Z 平面的母线矢高 z0
cy = 1 / Ry;
% 计算基准二次曲线部分
z_conic = (cy .* Y.^2) ./ (1 + sqrt(1 - (1 + K) .* cy^2 .* Y.^2));
% 加上高阶非球面项
z0 = z_conic + A.*Y.^4 + B.*Y.^6 + C.*Y.^8 + D.*Y.^10;
hold on
plot(Y,z0)

axis equal
% ylim([-5 5])