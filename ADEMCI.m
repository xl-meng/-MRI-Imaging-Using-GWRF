clc;clear;
load('feature_filter_MulGeneP_AD_EMCI.mat');
load('train_valid_ADEMCI.mat');
RF_Acc=zeros(12,1);
CLU_Acc=zeros(11,20);CLU_Acc1=zeros(10,12);CLU_Acc1_loc=zeros(10,12);
% GA_Acc1=zeros(10,12);GA_Acc1_loc=zeros(10,12);
CL_GA_Acc1=zeros(10,12);CL_GA_Acc1_loc=zeros(10,12);
RF_Acc_final=zeros(12,1);
CLU_Acc_final=zeros(11,12);
GA_Acc_final=zeros(11,12);
CL_GA_Acc_final=zeros(11,12);%定义要存储数据的变量
AD = -ones(1, 296);
EMCI = ones(1, 271);%给AD和HC设定标签数目，AD为-1，EMCI为1
labels = [EMCI, AD];%组合标签
x=all_x(20,:);%随机生成一个矩阵，大小为567*1，值为1-567  
N_train = floor(0.6 * 567);%取60%为训练集
N_v = floor(0.2 * 567);%取20%为验证集
N_test = 567-N_train-N_v;%取20%为测试集

train_ = x(1:N_train);%取对应的index
v_ = x(N_train+1:N_train+N_v);
test_ = x(N_train+N_v+1:567);

PRECT = length(feature_filter_MulGeneP_AD_EMCI); %特征的总数 

for NIND=300:20:500
     fprintf('processing start!\n');
     fprintf('processing ---->%dth\n',NIND);
                                     
     Chrom = zeros(NIND, PRECT);
    for loop=1:12
    for i = 1:NIND
        temp = randsample(PRECT, 209);% 209^2 = 43460 从43460中随机取209个
        Chrom(i, temp) = 1;
    end
    %build the decision trees
    feature=zeros(NIND,209);%存储209个随机位置

    for aa=1:NIND
        feature(aa,:) = randsample(PRECT, 209, 'true'); %随机取209个存在feature中
    end

    %遗传次数
    NG=50;

    % 随机森林 & 随机森林+权重
    [Acc_RF_final,Acc_RF_Weighted_final,Acc_valid,result_valid,result_rf,result_wrf,v_lab,test_lab] = RF_use(feature,NIND,feature_filter_MulGeneP_AD_EMCI,labels,train_,v_,N_v,test_,N_test);
    %保存验证集结果
    name = sprintf('Acc_RF_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid);
    name = sprintf('Acc_RF_Weighted_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid);
    name = sprintf('label_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  v_lab);
    name = sprintf('label_test_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  test_lab);
    name = sprintf('output_RF_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_valid);
    % 保存测试集结果
    name = sprintf('Acc_RF_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_final);
    name = sprintf('Acc_RF_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_Weighted_final);
    %保存测试集预测结果
    name = sprintf('output_RF_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_rf);
    name = sprintf('output_RF_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_wrf);
    name = sprintf('sample_RF_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  feature);


    % 随机森林+权重+遗传 & 随机森林+遗传
    [Acc_RF_GA_final,Acc_valid1,result_ga_valid,result_garf,sample_ga] = GA_RF_use(PRECT,feature,NG,NIND,feature_filter_MulGeneP_AD_EMCI,labels,train_,v_,N_v,test_,N_test);
    [Acc_RF_GA_Weighted_final,Acc_valid2,result_gawf_valid,result_gawrf,sample_gawf] = GAWF_RF_use(PRECT,feature,NG,NIND,feature_filter_MulGeneP_AD_EMCI,labels,train_,v_,N_v,test_,N_test);
    %保存验证集结果
    name = sprintf('Acc_RF_GA_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid1);
    name = sprintf('Acc_RF_GA_Weighted_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid2);
    % 保存测试集结果
    name = sprintf('Acc_RF_GA_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_GA_final);
    name = sprintf('Acc_RF_GA_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_GA_Weighted_final);
     %保存测试集预测结果
    name = sprintf('output_RF_GA_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_ga_valid);
    name = sprintf('output_RF_GA_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_garf);
    name = sprintf('output_RF_GA_Weighted_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_gawf_valid);
    name = sprintf('output_RF_GA_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_gawrf);
    
    name = sprintf('sample_RF_GA_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  sample_ga);
    name = sprintf('sample_RF_GAWF_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  sample_gawf);
    end
end
           
        