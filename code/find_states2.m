function train_data=find_states2(train_data,thresh_break,num_code)
    odata=[];
    for i=1:numel(train_data)
        max_states = 3*train_data(i).num_code;
        len_states=zeros(1,numel(train_data(i).trial));
        %states = zeros(1, max_states);
        for t=1:numel(train_data(i).trial)
            tplot=train_data(i).trial(t).obs;
            %plot(transpose(tplot));
            %hold on;
            tid=train_data(i).trial(t).code;
            %plot(tid);
            %title(['# ',num2str(t),' of ',num2str(numel(train_data(i).trial)),' trials for dataset ',num2str(i)]);
            [pks,locs] = findpeaks(abs(diff(tid)));
            %[pks ,locs] = find( diff(locs)<thresh_break); % State breaks
            %plot( locs, pks>0, 'k*' );
            % Go through and accumulate state observations
            % all points before break 1 are state 1,
            % all points before break 2 and after break 1 are state 2, etc.
            if( numel(locs)>1 )
                tmp=[];
                len=[];
                tmp(1)=mode( tid(1:locs(1)) ); 
                len(1)= numel(tid(1:locs(1)));
                dummy(t).tid=tid;
                dummy(t).locs=locs;
                for j= 2:numel(locs)
                    tmp(j) = mode(tid(locs(j-1)+1:locs(j)));
                    len(j)= numel(tid(locs(j-1)+1:locs(j)));
                end
                tmp(numel(locs)+1) = mode(tid(locs(j)+1:end ) );
                len(numel(locs)+1)= numel(tid(locs(j)+1:end ));
                train_data(i).trial(t).states = tmp;
                train_data(i).trial(t).len = len;
                %[numel(train_data(i).trial(t).code) sum(len)]
            end
            %legend(num2str(numel(tmp)));
            len_states(t)=numel(train_data(i).trial(t).states);
            %hold off;
            %pause(0.01);
        end
        num_states=mode(len_states);
        for r=1:numel(train_data(i).trial)
            tval=numel(train_data(i).trial(r).states)-num_states;
            tstates=train_data(i).trial(r).states;
            tlen=train_data(i).trial(r).len;
            if (tval>0)
                [val,idx]=sort(train_data(i).trial(r).len,'ascend');
                for j=1:tval
                    if (idx(j)==1)
                        tstates(idx(j))=tstates(idx(j)+1);
                        tlen(idx(j))=tlen(idx(j))+tlen(idx(j)+1);
                        tlen(idx(j)+1)=tlen(idx(j));
                    elseif (idx(j)==numel(idx))
                        tstates(idx(j))=tstates(idx(j)-1);
                        tlen(idx(j)-1)=tlen(idx(j));
                    elseif (val(idx(j)+1)> val(idx(j)-1))
                        tstates(idx(j))=tstates(idx(j)+1);
                        tlen(idx(j)+1)=tlen(idx(j));
                    else
                        tstates(idx(j))=tstates(idx(j)-1);
                        tlen(idx(j)-1)=tlen(idx(j));
                    end
                end
                %numel(tstates)
                %numel(tlen)
                %diff([0 tstates])
                %pause
                tmps=diff([0 tstates]);
                sts=zeros(size(tmps));
                kk=0;
                for w=1:numel(tmps)
                    if (tmps(w)~=0)
                        sts(w)=kk+1;
                        kk=kk+1;
                    else
                        sts(w)=kk;
                    end
                end
                tmp=zeros(size(train_data(i).trial(r).code));
                tmp(1:dummy(r).locs(1))=sts(1); 
                for j= 2:numel(dummy(r).locs)
                    tmp(1+dummy(r).locs(j-1):dummy(r).locs(j))=sts(j);
                end
                tmp(1+dummy(r).locs(j):end)=sts(numel(dummy(r).locs)+1) ;
                train_data(i).trial(r).states=tstates(diff([0 tstates])~=0);
                train_data(i).trial(r).len=tlen(diff([0 tstates])~=0);
                train_data(i).trial(r).flag=1;
            elseif(tval<0)
                train_data(i).trial(r).flag=0;
                tmp=[];
            else
                if (numel(tstates)==0)
                    train_data(i).trial(r).flag=0;
                else
                train_data(i).trial(r).flag=1;
                sts=[];
                sts=1:numel(tstates);
                tmp=zeros(size(train_data(i).trial(r).code));
                tmp(1:dummy(r).locs(1))=sts(1); 
                for j= 2:numel(dummy(r).locs)
                    tmp(1+dummy(r).locs(j-1):dummy(r).locs(j))=sts(j);
                end
                tmp(1+dummy(r).locs(j):end)=sts(numel(dummy(r).locs)+1) ;
                end
            end
            train_data(i).trial(r).sts=tmp;
        end
        
        train_data(i).num_states=num_states;
    end
    for i=1:numel(train_data)
        ttrial=[];
        cnt=1;
        for j=1:numel(train_data(i).trial)
            if (train_data(i).trial(j).flag==1)
                ttrial(cnt).code=train_data(i).trial(j).code;
                ttrial(cnt).obs=train_data(i).trial(j).obs;
                ttrial(cnt).state_val=train_data(i).trial(j).states;
                ttrial(cnt).states=train_data(i).trial(j).sts;
                cnt=cnt+1;
            end
        end
        train_data(i).trial=ttrial;
    end
end