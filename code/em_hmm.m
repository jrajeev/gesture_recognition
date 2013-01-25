function [A,B]=em_hmm(A,B,C,train_data)
    num_states=size(A,1);
    num_code=size(B,1);
    epsilon=zeros(num_states,num_states);
    gamma=zeros(num_states,1);
    gamma_n=zeros(num_code,num_states);
    t1=CTimeleft(10);
    for num=1:10
        t1.timeleft();
        for k=1:numel(train_data.trial)
            obs=train_data.trial(k).code;
            [alpha, beta, alpha_norm_fact, ll]=forward_backward(A,B,C,obs);
            tmpe=zeros(num_states,num_states,numel(obs));
            tmpgn=zeros(num_code,num_states);
            for t=1:numel(obs)-1
                for i=1:num_states
                    tmpe(i,:,t)=alpha(i,t)*(A(i,:).*B(obs(t+1),:).*transpose(beta(:,t+1)));
                end
                tmpe(:,:,t)=tmpe(:,:,t)/sum(sum(tmpe(:,:,t)));
            end
            epsilon=epsilon+sum(tmpe,3);
            %szepsil=size(epsilon)
            %sztmpe=size(tmpe)
            tmpg=[];
            tmpg(:,:)=sum(tmpe,2);
            %sztmpg=size(tmpg)
            for j=1:num_code
                mask=(obs==j);
                tmpgn(j,:)=transpose(sum(tmpg(:,mask),2));
            end
            %sztmpgn=size(tmpgn)
            gamma_n=gamma_n+tmpgn;
            %szgamma_n=size(gamma_n)
            gamma=gamma+sum(tmpg,2);
            %szgamma=size(gamma)
        end
        A=bsxfun(@rdivide,epsilon,gamma);
        B=bsxfun(@rdivide,gamma_n,gamma');
    end
end