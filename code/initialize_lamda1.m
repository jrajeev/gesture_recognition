function [lamda]=initialize_lamda1(codebook)
    lamda=[];
    for i=1:numel(codebook)
        num_states=codebook(i).num_states;
        num=zeros(num_states,num_states);
        nocc=zeros(1,num_states);
        %A=zeros(num_states,num_states);
        %B=zeros(codebook(i).num_clusters,num_states);
        %C=zeros(1,codebook(i).num_states);
        C=[1 zeros(1,codebook(i).num_states-1)];
        nobs=zeros(codebook(i).num_clusters,num_states);
        for j=1:numel(codebook(i).trial)
            for k=1:codebook(i).num_states
                sidx=(codebook(i).trial(j).states==k);
                nidx=(codebook(i).trial(j).states==k+1);
                nocc(k)=nocc(k)+sum(sidx);
                if (k<codebook(i).num_states)
                    num(k,k)=num(k,k)+sum([0 sidx].*[sidx 0]);
                    num(k,k+1)=num(k,k+1)+sum([0 sidx].*[nidx 0]);
                end
                for ob=1:codebook(i).num_clusters
                    oidx=(codebook(i).trial(j).code==ob);
                    %[i j]
                    %numel(sidx)
                    %numel(oidx)
                    nobs(ob,k)=nobs(ob,k)+sum(sidx.*oidx);
                end
            end
        end
        B=bsxfun(@rdivide,nobs,nocc);
        B=B+1e-4;
        B=bsxfun(@rdivide,B,sum(B,1));
        num(num_states,num_states)=1;
        nocc(num_states)=1;
        A=bsxfun(@rdivide,num,nocc);
        A=bsxfun(@rdivide,A,sum(A,2));
        lamda(i).A=A;
        lamda(i).B=B;
        lamda(i).C=C;
    end
end