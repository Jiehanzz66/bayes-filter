%% 导入数据
addpath('C:\Users\jiehanzz\Desktop\sauanfa\GEF2017');
opts = detectImportOptions('GEF2017.csv');
preview('GEF2017.csv',opts);
for i =8:14
opts.VariableTypes{i}='categorical';
end
%
opts.SelectedVariableNames = [1:15]; 
opts.DataLines = [2,17520];
load=readtable('GEF2017.csv',opts);

clearvars -except load
%  预处理
load.month =dummyvar(load.month);
%
load.hour=dummyvar(load.hour);
load.day_of_week =dummyvar(load.day_of_week);
load.weekend =double(load.weekend)-1;
load.holiday =double(load.holiday)-1;
load.holiday_name =[];
load.day_of_year=[];
load.date=[];
load.year=[];
load.zone=[];
% 数据集划分
corrplot(load(:,2:4))
% 添加特征 (交互影响）
load.crossmonth =load.drybulb.*load.month;
load.crosshourweekday =load.hour.*load.weekend;
load.crossdewpnt = load.dewpnt.*load.month;
load.drybulb2 =load.drybulb.^2;
load.dewpnt2 =load.dewpnt.^2;
load =movevars(load,{'drybulb2','dewpnt2','trend'},'Before','month');
% 预测
ypred =CnnLstm(load);











