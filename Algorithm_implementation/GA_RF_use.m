function [Acc_RF_GA_final,Acc_valid1,output_valid,output_final,sample_loc]=GA_RF_use(PRECT,sample_loc,N,NIND,feature_orig,labels,train_,v_,N_v,test_,N_test)
 
v_lab = labels(v_);
train_lab=labels(train_);
test_lab = labels(test_);
    
%保存每一次遗传的结果 
Acc1=zeros(N,1);
Acc_valid=zeros(N,1);
Result1=zeros(N,length(test_));
Result=zeros(N,length(v_));

% 循环NG遗传次数
 for loopnum=1:N
    tic;
    Gennum=length(sample_loc(:,1));
    new_sample_loc=zeros(Gennum,209);

    for i=1:Gennum
        intersect_1=zeros(2,209);
        for intersect_num = 1:2%初始化父本和母本，分别从5组特征中挑选最优的一组
            
            len=5;
            num_F=randsample(Gennum,len);%生成5个位置
            sample_fc=sample_loc(num_F,:);%从决策树中挑选对应的5个
            for k=1:len
                Acc_clu=zeros(len,1);
                train_lab=labels(train_);
                fc_temp = randsample(209, 209);%rand [1,110] in 1*110  
                train_set = feature_orig(train_, sample_fc(k,fc_temp));
                tree = fitctree(train_set, train_lab);   %构建决策树    

                v_set = feature_orig(v_, sample_fc(k,fc_temp));
                v_lab = labels(v_);                                                                                                                                                                                                                              
                output = predict(tree, v_set);  %结果预测
                Acc1 = sum(v_lab' == output)/length(v_lab);
                Acc_clu(k,1)=Acc1;
            end
            newloc=find(Acc_clu==max(Acc_clu));
            intersect_1(intersect_num,:)=sample_fc(newloc,:);
        end
        
        %交叉遗传
        interaction_loc=randi(208);
        r1=rand();
        if r1<0.9
                new_sample_loc(i,1:interaction_loc)=intersect_1(1,1:interaction_loc);
                new_sample_loc(i,interaction_loc+1:209)=intersect_1(2,interaction_loc+1:209);
        else
                new_sample_loc(i,:)=intersect_1(1,:);
        end
        r2=rand();
        if r2<=0.1%变异
            new_sample_loc(i,:)=randperm(PRECT,209);
        end
    end
    
    %对遗传new_sample_loc进行构建决策树
    output = zeros(NIND,N_v);% N=300
    for i = 1:NIND 
        fc_temp = randsample(209, 209);
        train_set = feature_orig(train_, new_sample_loc(i,fc_temp));
        tree = fitctree(train_set, train_lab);   %构建决策树    
        %验证集计算
        v_set = feature_orig(v_, new_sample_loc(i,fc_temp));
        output(i, :) = predict(tree, v_set);  %结果预测
        
        v_test = feature_orig(test_, new_sample_loc(i,fc_temp));
        output1(i, :) = predict(tree, v_test);  %结果预测
    end
    
    %初始随机森林的验证集准确率
    Res_sum = sum(output);
    Result(loopnum,:)  = sign(Res_sum);
    R = sum(Result(loopnum,:)  == v_lab);
    %['准确率：' num2str(R/length(z))]
    JQ_Acc = R/N_v;
    Acc_valid(loopnum,1)=JQ_Acc;
    
    %初始随机森林的测试集准确率
    Res_sum = sum(output1);
    Result1(loopnum,:) = sign(Res_sum);
    R = sum(Result1(loopnum,:) == test_lab);
    %['准确率：' num2str(R/length(z))]
    JQ_Acc = R/N_test;
    Acc1(loopnum,1)=JQ_Acc;
    toc;
    sample_loc = new_sample_loc;
 end

 %筛选出准确率最高的值
[As,ind]=sort(Acc_valid);
Acc_valid1=As(end);
output_valid=Result(ind(end),:);

Acc_RF_GA_final=Acc1(ind(end));
output_final=Result1(ind(end),:);

end