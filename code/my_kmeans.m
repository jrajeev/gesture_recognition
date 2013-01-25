function [mumean,cluster_id]=my_kmeans(vec,K,trial)
    if (nargin==1)
        K=5;
        trial=10;
    end
    mumean=zeros(size(vec,1),K);
    preverr=2000000;
    prevmean=mumean;
    for trialcnt=1:trial %taking best out of 10 trials
        %initialization
        for i=1:K
            idx=randi(size(vec,2));
            mumean(:,i)=vec(:,idx);
        end
        dist=zeros(K,size(vec,2));
        previdx=zeros(1,size(vec,2));
        err=numel(previdx);
        thresh_kmeans=0.0001;
        cnt=0;
        run=30;
        %err>thresh_kmeans && 
        while (cnt<run)
            %Assigning Cluster based on old means
            for i=1:K
                tmp=bsxfun(@minus,vec,mumean(:,i));
                dist(i,:)=sum(tmp.*tmp,1);
            end
            [val,minidx]=min(dist,[],1);
            err=sum(val);
            %Computing new means
            for i=1:K
                mumean(:,i)=sum(bsxfun(@times,vec,(minidx==i)),2)/sum(minidx==i);
            end
            %err=sum((previdx-minidx)~=0)/numel(minidx);
            previdx=minidx;
            cnt=cnt+1;
        end
        %fprintf('Trial # %d : Kmeans fractional change = %f | #iterations = %d\n',trialcnt,err,cnt);
        if (err<preverr)
            preverr=err;
            %Sort means in order of distance from the center
            norm_mumean=sum(mumean.*mumean,1);
            [val,sortidx]=sort(norm_mumean,'ascend');
            mumean=mumean(:,sortidx);
            %Assigning Final Cluster ID
            for i=1:K
                tmp=bsxfun(@minus,vec,mumean(:,i));
                dist(i,:)=sum(tmp.*tmp,1);
            end
            [val,cluster_id]=min(dist,[],1);
            prevmean=mumean;
        end
        
    end
    mumean=prevmean;
    %preverr
end