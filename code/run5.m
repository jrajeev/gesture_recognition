%% Load Data
clear
clc
load('processed_gesture_pack.mat');

%% Vector Quantization : K-means on Data to create codebook
num_code=30;
thresh_trials=[33 40 40 40 40 40 200 200 200 200 200 270];
kmeansk=      [3  3  3  3  3  3  4 4 3 3 3 3];
codebook=[];
t=CTimeleft(numel(pdata));
for i=1:numel(pdata)
    t.timeleft();
    codebook(i).num_clusters=num_code;
    [codebook(i).mumean codebook(i).cluster_id]=my_kmeans(pdata{i}.imu,kmeansk(i),10);
    codebook(i).imu=pdata{i}.imu;
    %prune 5% end data
    sz=numel(codebook(i).cluster_id);
    codebook(i).cluster_id=codebook(i).cluster_id(1:sz-floor(0.05*sz));
    sz=numel(codebook(i).cluster_id);
    %plot(1:size(pdata{i}.imu,2),codebook(i).cluster_id);
    %hold on
    [pks,locs]=findpeaks(abs([0 diff(codebook(i).cluster_id)]));
    trial_breaks=find(diff(locs)>=thresh_trials(i));
    tmp=diff([0  locs(trial_breaks)]);
    offset=floor(0.05*tmp);
    trial_breaks=[(locs(trial_breaks)+offset) sz];
    [codebook(i).mumean codebook(i).cluster_id]=my_kmeans(pdata{i}.imu,num_code,10);
    prev=1;
    %fprintf('hello\n');
    for j=1:numel(trial_breaks)
        codebook(i).trial(j).code=codebook(i).cluster_id(prev:trial_breaks(j));
        codebook(i).trial(j).imu=codebook(i).imu(:,prev:trial_breaks(j));
        prev=trial_breaks(j)+1;
    end
    %plot(locs(trial_breaks),pks(trial_breaks),'or','MarkerSize',5,'MarkerFaceColor','r')
    %pause;
    %hold off
end
save('codebook1.mat','codebook');
%%
load('codebook1.mat');
codebook=find_states1(codebook,30,num_code);
save('codebook.mat','codebook');
%%
lamda=initialize_lamda1(codebook);
save('lamda.mat','lamda');