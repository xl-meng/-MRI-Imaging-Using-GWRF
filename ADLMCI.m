clc;clear;
load('feature_filter_MulGeneP_AD_LMCI.mat');
load('all_x.mat');
RF_Acc=zeros(12,1);
CLU_Acc=zeros(11,20);CLU_Acc1=zeros(10,12);CLU_Acc1_loc=zeros(10,12);
% GA_Acc1=zeros(10,12);GA_Acc1_loc=zeros(10,12);
CL_GA_Acc1=zeros(10,12);CL_GA_Acc1_loc=zeros(10,12);
RF_Acc_final=zeros(12,1);
CLU_Acc_final=zeros(11,12);
GA_Acc_final=zeros(11,12);
CL_GA_Acc_final=zeros(11,12);%����Ҫ�洢���ݵı���
AD = -ones(1, 296);
LMCI = ones(1, 390);%��AD��HC�趨��ǩ��Ŀ��ADΪ-1��LMCIΪ1
labels = [LMCI, AD];%��ϱ�ǩ
x=all_x(84,:);%�������һ�����󣬴�СΪ686*1��ֵΪ1-686  
N_train = floor(0.6 * 686);%ȡ60%Ϊѵ����
N_v = floor(0.2 * 686);%ȡ20%Ϊ��֤��
N_test = 686-N_train-N_v;%ȡ20%Ϊ���Լ�

train_ = x(1:N_train);%ȡ��Ӧ��index
v_ = x(N_train+1:N_train+N_v);
test_ = x(N_train+N_v+1:686);
PRECT = length(feature_filter_MulGeneP_AD_LMCI); %���������� 

for NIND=300:20:500
     fprintf('processing start!\n');
     fprintf('processing ---->%dth\n',NIND);
                                     
     Chrom = zeros(NIND, PRECT);
    for loop=1:12
    for i = 1:NIND
        temp = randsample(PRECT, 209);% 209^2 = 43460 ��43460�����ȡ209��
        Chrom(i, temp) = 1;
    end
    %build the decision trees
    feature=zeros(NIND,209);%�洢209�����λ��

    for aa=1:NIND
        feature(aa,:) = randsample(PRECT, 209, 'true'); %���ȡ209������feature��
    end

    %�Ŵ�����
    NG=50;

    % ���ɭ�� & ���ɭ��+Ȩ��
    [Acc_RF_final,Acc_RF_Weighted_final,Acc_valid,result_valid,result_rf,result_wrf,v_lab,test_lab] = RF_use(feature,NIND,feature_filter_MulGeneP_AD_LMCI,labels,train_,v_,N_v,test_,N_test);
    %������֤�����
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
    % ������Լ����
    name = sprintf('Acc_RF_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_final);
    name = sprintf('Acc_RF_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_Weighted_final);
    %������Լ�Ԥ����
    name = sprintf('output_RF_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_rf);
    name = sprintf('output_RF_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  result_wrf);
    name = sprintf('sample_RF_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  feature);


    % ���ɭ��+Ȩ��+�Ŵ� & ���ɭ��+�Ŵ�
    [Acc_RF_GA_final,Acc_valid1,result_ga_valid,result_garf,sample_ga] = GA_RF_use(PRECT,feature,NG,NIND,feature_filter_MulGeneP_AD_LMCI,labels,train_,v_,N_v,test_,N_test);
    [Acc_RF_GA_Weighted_final,Acc_valid2,result_gawf_valid,result_gawrf,sample_gawf] = GAWF_RF_use(PRECT,feature,NG,NIND,feature_filter_MulGeneP_AD_LMCI,labels,train_,v_,N_v,test_,N_test);
    %������֤�����
    name = sprintf('Acc_RF_GA_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid1);
    name = sprintf('Acc_RF_GA_Weighted_valid_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_valid2);
    % ������Լ����
    name = sprintf('Acc_RF_GA_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_GA_final);
    name = sprintf('Acc_RF_GA_Weighted_final_%d_%d.xlsx',NIND,loop);
    xlswrite(name,  Acc_RF_GA_Weighted_final);
     %������Լ�Ԥ����
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