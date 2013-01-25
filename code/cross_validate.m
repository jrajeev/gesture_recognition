%% cross validate
err=zeros(1,50);
for num_code=7:7
    fprintf('For num_code = %d\n',num_code);
    train_data=separate_trials(train_data1,breakpts,num_code);
    train_data=find_states2(train_data);
    cnt=0;
    for i=1:numel(train_data)
        for j=1:numel(train_data(i).trial)
            lamda=initialize_lamda_c(train_data,i,j);
            test_data=train_data(i).trial(j);
            ll=zeros(1,numel(lamda));   
            for m=1:numel(lamda)
                if (numel(lamda(m).A)==0 || numel(lamda(m).B)==0)
                    continue;
                end
                [alpha, beta, alpha_norm_fact, ll(m)]=forward_backward(lamda(m).A,lamda(m).B,lamda(m).C,test_data.code);
                cnt=cnt+1;
            end
            [val,idx]=sort(ll,'ascend');
            if (idx(1)==i)
                err(num_code)=err(num_code)+0;
            elseif (idx(2)==i)
                err(num_code)=err(num_code)+1;
            elseif (idx(3)==i)
                err(num_code)=err(num_code)+1;
            else
                err(num_code)=err(num_code)+1;
            end
        end
    end
    err(num_code)=err(num_code)/cnt;
end