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
        tree = fitctree(train_set, train_lab);   %构建决策树
        
        %验证集计算
        v_set = feature_orig(v_, sample_loc(i,fc_temp));
        output(i, :) = predict(tree, v_set);  %结果预测
        
        %计算准确率
        Acc(i) = sum(v_lab == output(i, :))/length(v_lab);
        
        %测试集计算
        v_test = feature_orig(test_, sample_loc(i,fc_temp));
        output1(i, :) = predict(tree, v_test);  %结果预测
    end

   %初始随机森林的验证集准确率
    Res_sum = sum(output);
    Result = sign(Res_sum);
    R = sum(Result == v_lab);
    %['准确率：' num2str(R/length(z))]
    Acc_valid = R/N_v;
        
    %初始随机森林的测试集准确率
    Res_sum1 = sum(output1);
    Result1 = sign(Res_sum1);
    R = sum(Result1 == test_lab);
    Acc_RF_final = R/N_test;
 
    
    %权重随机森林的测试集准确率
    result = zeros(1, length(test_));
    for i = 1:length(test_)
        result(i) = sum(output1(:, i) .* Acc');
    end
    result1 = sign(result);
    R = sum(result1 == test_lab);
    Acc_RF_Weighted = R/N_test;
    
end