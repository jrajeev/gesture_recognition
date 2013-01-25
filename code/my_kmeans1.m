function [mumean,cluster_id]=my_kmeans1(vec,K,trial)
    if (nargin==1)
        K=5;
    end
    mumean=zeros(size(vec,1),K);
    preverr=2;
    prevmean=mumean;
    %for trialcnt=1:trial %taking best out of 10 trials
        %initialization
        for i=1:K
            idx=floor((i-1)*size(vec,2)/K)  + 0*randi(floor(size(vec,2)/K))+1;
            if(idx>size(vec,2)) 
                idx=size(vec,2);
            end
            mumean(:,i)=vec(:,idx);
        end
        dist=zeros(K,size(vec,2));
        previdx=zeros(1,size(vec,2));
        err=numel(previdx);
        thresh_kmeans=0.0001;
        cnt=0;
        run=500;
        while (cnt<run)
            %Assigning Cluster based on old means
            for i=1:K
                tmp=bsxfun(@minus,vec,mumean(:,i));
                dist(i,:)=sum(tmp.*tmp,1);
            end
            [val,minidx]=min(dist,[],1);
            %Computing new means
            for i=1:K
                mumean(:,i)=sum(bsxfun(@times,vec,(minidx==i)),2)/sum(minidx==i);
            end
            err=sum((previdx-minidx)~=0)/numel(minidx);
            previdx=minidx;
            cnt=cnt+1;
        end
        for i=1:K
            tmp=bsxfun(@minus,vec,mumean(:,i));
            dist(i,:)=sum(tmp.*tmp,1);
        end
        [val,cluster_id]=min(dist,[],1);
    %end
    mumean=prevmean;
end