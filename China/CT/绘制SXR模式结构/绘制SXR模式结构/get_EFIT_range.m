% 该函数用于读取EFIT数据保存范围
% 韩玉箫 2024年03月25日

function [t_EFIT_list]=get_EFIT_range(path)

%下面读取EFIT数据的时刻列表
EFIT_time_parameters=importdata(path,'%d');
EFIT_time=extract(EFIT_time_parameters,regexpPattern('\d*'));

dt_EFIT=str2double(EFIT_time{1});
t_start_EFIT=str2double(EFIT_time{2});
t_edn_EFIT=str2double(EFIT_time{3});

t_EFIT_list=t_start_EFIT:dt_EFIT:t_edn_EFIT;

end