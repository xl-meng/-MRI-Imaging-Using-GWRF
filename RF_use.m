function [Acc_RF_final,Acc_RF_Weighted,Acc_valid,Result,Result1,result1,v_lab,test_lab]=RF_use(sample_loc,NIND,feature_orig,labels,train_,v_,N_v,test_,N_test)
    Acc_RF_final=1;
    Acc_RF_Weighted=1;
    output = zeros(NIND,N_v);% N=300
    output1 = zeros(NIND,N_test);% N=300
    v_lab = labels(v_);
    train_lab=labels(train_);
    test_lab = labels(test_);
    Acc=[];
    for i = 1:NIND 

        fc_temp = randsample(209, 209);%rand [1,110] in 1*110  
        train_set = feature_orig(train_, sample_loc(i,fc_temp));
        tree = fitctree(train_set, train_lab);   %����������
        
        %��֤������
        v_set = feature_orig(v_, sample_loc(i,fc_temp));
        output(i, :) = predict(tree, v_set);  %���Ԥ��
        
        %����׼ȷ��
        Acc(i) = sum(v_lab == output(i, :))/length(v_lab);
        
        %���Լ�����
        v_test = feature_orig(test_, sample_loc(i,fc_temp));
        output1(i, :) = predict(tree, v_test);  %���Ԥ��
    end

   %��ʼ���ɭ�ֵ���֤��׼ȷ��
    Res_sum = sum(output);
    Result = sign(Res_sum);
    R = sum(Result == v_lab);
    %['׼ȷ�ʣ�' num2str(R/length(z))]
    Acc_valid = R/N_v;
        
    %��ʼ���ɭ�ֵĲ��Լ�׼ȷ��
    Res_sum1 = sum(output1);
    Result1 = sign(Res_sum1);
    R = sum(Result1 == test_lab);
    Acc_RF_final = R/N_test;
 
    
    %Ȩ�����ɭ�ֵĲ��Լ�׼ȷ��
    result = zeros(1, length(test_));
    for i = 1:length(test_)
        result(i) = sum(output1(:, i) .* Acc');
    end
    result1 = sign(result);
    R = sum(result1 == test_lab);
    Acc_RF_Weighted = R/N_test;
    
end