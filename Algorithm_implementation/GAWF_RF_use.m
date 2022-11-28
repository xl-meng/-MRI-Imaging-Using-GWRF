function [Acc_RF_GA_Weighted,Acc_valid2,output_valid,output_final1,sample_loc]=GAWF_RF_use(PRECT,sample_loc,N,NIND,feature_orig,labels,train_,v_,N_v,test_,N_test)
 
v_lab = labels(v_);
train_lab=labels(train_);
test_lab = labels(test_);
    
%����ÿһ���Ŵ��Ľ�� 
Acc1=zeros(N,1);
Acc_Weighted=zeros(N,1);
Acc_valid=zeros(N,1);
Result1=zeros(N,length(test_));
result1=zeros(N,length(test_));

% ѭ��NG�Ŵ�����
 for loopnum=1:N
    tic;
    Gennum=length(sample_loc(:,1));
    new_sample_loc=zeros(Gennum,209);

    for i=1:Gennum
        intersect_1=zeros(2,209);
        for intersect_num = 1:2%��ʼ��������ĸ�����ֱ��5����������ѡ���ŵ�һ��
            
            len=5;
            num_F=randsample(Gennum,len);%����5��λ��
            sample_fc=sample_loc(num_F,:);%�Ӿ���������ѡ��Ӧ��5��
            for k=1:len
                Acc_clu=zeros(len,1);
                train_lab=labels(train_);
                fc_temp = randsample(209, 209);%rand [1,110] in 1*110  
                train_set = feature_orig(train_, sample_fc(k,fc_temp));
                tree = fitctree(train_set, train_lab);   %����������    

                v_set = feature_orig(v_, sample_fc(k,fc_temp));
                v_lab = labels(v_);                                                                                                                                                                                                                              
                output = predict(tree, v_set);  %���Ԥ��
                Acc1 = sum(v_lab' == output)/length(v_lab);
                Acc_clu(k,1)=Acc1;
            end
            newloc=find(Acc_clu==max(Acc_clu));
            intersect_1(intersect_num,:)=sample_fc(newloc,:);
        end
        
        %�����Ŵ�
        interaction_loc=randi(208);
        r1=rand();
        if r1<0.9
                new_sample_loc(i,1:interaction_loc)=intersect_1(1,1:interaction_loc);
                new_sample_loc(i,interaction_loc+1:209)=intersect_1(2,interaction_loc+1:209);
        else
                new_sample_loc(i,:)=intersect_1(1,:);
        end
        r2=rand();
        if r2<=0.1%����
            new_sample_loc(i,:)=randperm(PRECT,209);
        end
    end
    
    %���Ŵ�new_sample_loc���й���������
    output = zeros(NIND,N_v);% N=300
    output1 = zeros(NIND,N_test);% N=300
    Acc=[];
    for i = 1:NIND 
        fc_temp = randsample(209, 209);
        train_set = feature_orig(train_, new_sample_loc(i,fc_temp));
        tree = fitctree(train_set, train_lab);   %����������    
        %��֤������
        v_set = feature_orig(v_, new_sample_loc(i,fc_temp));
        output(i, :) = predict(tree, v_set);  %���Ԥ��
        %����׼ȷ��
        Acc(i) = sum(v_lab == output(i, :))/length(v_lab);
        %���Լ�����
        v_test = feature_orig(test_, new_sample_loc(i,fc_temp));
        output1(i, :) = predict(tree, v_test);  %���Ԥ��
    end
    
    %��ʼ���ɭ�ֵ���֤��׼ȷ��
    Res_sum = sum(output);
    Result(loopnum,:)  = sign(Res_sum);
    R = sum(Result(loopnum,:)  == v_lab);
    %['׼ȷ�ʣ�' num2str(R/length(z))]
    JQ_Acc = R/N_v;
    Acc_valid(loopnum,1)=JQ_Acc;
    

    %Ȩ�����ɭ�ֵĲ��Լ�׼ȷ��
    result = zeros(1, length(test_));
    for i = 1:length(test_)
        result(i) = sum(output1(:, i) .* Acc');
    end
    result1(loopnum,:) = sign(result);
    R = sum(result1(loopnum,:) == test_lab);
    %['׼ȷ�ʣ�' num2str(R/length(z))]
    JQ_Acc1 = R/N_test;
    Acc_Weighted(loopnum,1)=JQ_Acc1;

    sample_loc = new_sample_loc;
    toc;
 end

 %ɸѡ��׼ȷ����ߵ�ֵ
[As,ind]=sort(Acc_valid);
Acc_valid2=As(end);
output_valid=Result(ind(end),:);

Acc_RF_GA_Weighted=Acc_Weighted(ind(end));
output_final1=result1(ind(end),:);

end