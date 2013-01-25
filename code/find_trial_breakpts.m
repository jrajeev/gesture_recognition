function breakpts=find_trial_breakpts(train_data,thresh_trials,Kmat)
    breakpts=[];
    for i=1:numel(train_data)
        % Quantize the imu readings to codes
        codebook=vector_quantization(train_data(i).imu,Kmat(i));
        %plot(1:size(codebook.obs,2),codebook.code);
        %hold on

        %Find peaks pts and breaks and modified to include actual trial point
        %start
        [pks,locs]=findpeaks(abs([0 diff(codebook.code)]));
        trial_breaks=find(diff(locs)>=thresh_trials(i));
        
        %plot(locs(trial_breaks),pks(trial_breaks),'or','MarkerSize',5,'MarkerFaceColor','r')
        %title(strcat('Trial Breaks for dataset #',num2str(i),' :: ',train_data(i).name));
        %fname=strcat('../plots/Trial Breaks_D',num2str(i));
        %print ('-djpeg', '-r72',fname);
        %hold off
        
        tmp=diff([0  locs(trial_breaks)]);
        offset=floor(0.05*tmp);
        sz=numel(codebook.code);
        trial_breaks=[(locs(trial_breaks)+offset) sz];
        prev=1;
        for j=1:numel(trial_breaks)
            breakpts(i).st(j)=prev;
            breakpts(i).fin(j)=trial_breaks(j);
            prev=trial_breaks(j)+1;
        end
        
        %pause;
    end
end
