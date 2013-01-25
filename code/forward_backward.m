function [alpha, beta, alpha_norm_fact, ll]=forward_backward(A,B,C,obs)
    % A - the state transition matrix num_states x num_states
    % B - Emission probabilities num_obs_states x num_states
    % C - Initial state probabilities num_states x 1
    % obs - the discretized observations
    
    num_states=size(A,1);
    ts=size(obs,2);
    
    %Forward Procedure
    %initialize alpha
    alpha=zeros(num_states,ts);
    alpha_norm_fact=zeros(1,ts);
    alpha(:,1)=transpose(C.*B(obs(1),:));
    alpha_norm_fact(1)=sum(alpha(:,1));
    alpha(:,1)=alpha(:,1)/alpha_norm_fact(1);
    for t=2:ts
        for j=1:num_states
            alpha(j,t)=B(obs(t),j)*sum(alpha(:,t-1).*A(:,j));
        end
        %alpha(:,t)=transpose(B(obs(t),:).*transpose(alpha(:,t-1))*transpose(A));
        %Normalize alpha to prevent underflow
        alpha_norm_fact(t)=sum(alpha(:,t));
        if (alpha_norm_fact(t)~=0)
            alpha(:,t)=alpha(:,t)/alpha_norm_fact(t);
        end
    end
    if (any(alpha_norm_fact==0))
        ll=-inf;
    else
        ll=-sum(log(alpha_norm_fact),2);
    end
    %Backward Procedure
    %initialize beta
    beta=zeros(num_states,ts);
    beta(:,ts)=1/alpha_norm_fact(ts);
    for t=ts-1:-1:1
        for i=1:num_states
            beta(i,t)=sum(transpose(B(obs(t+1),:)).*(beta(:,t+1).*A(:,i)))/alpha_norm_fact(t);
        end
        %beta(:,t)=(transpose(B(obs(t+1),:)*bsxfun(@times,beta(:,t+1),A)))/alpha_norm_fact(t);
    end
end