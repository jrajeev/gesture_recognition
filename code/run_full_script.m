%% 
clear
clc
%%
[bias_accel, bias_gyro, train_old_data]=load_old_data();
save ('train_old_raw_data.mat','train_old_data','bias_accel','bias_gyro');
train_raw_data=[];
nameC={'frisbeeL','frisbeeR','shovelL','shovelR','swerveL','swerveR','dribble_shoot','figure8','jabs','lighter','lightsaber','windmill_dunk'};
for i=1:12
    load_new_data(strcat('../data/train_set/',nameC{i},'_imu.txt'));
    train_raw_data(i).class=i;
    train_raw_data(i).name=nameC{i};
    train_raw_data(i).accel=[accel_x'; accel_y'; accel_z'];
    train_raw_data(i).gyro=[gyro_x'; gyro_y'; gyro_z'];
    train_raw_data(i).imu=[train_raw_data(i).accel; train_raw_data(i).gyro];
end
%%
for i=7:12
    tmpA=[];
    tmpG=[];
    for j=1:numel(train_old_data{i-6}.data)
        tmpA=[tmpA train_old_data{i-6}.data{j}.accel];
        tmpG=[tmpG train_old_data{i-6}.data{j}.gyro];
    end
    train_raw_data(i).class=i;
    train_raw_data(i).name=nameC{i};
    train_raw_data(i).accel=tmpA;
    train_raw_data(i).gyro=tmpG;
    train_raw_data(i).imu=[train_raw_data(i).accel; train_raw_data(i).gyro];
end
%%
save('train_full_data.mat','train_raw_data','bias_accel','bias_gyro');
[train_data1]=process_train_data(train_raw_data,bias_accel,bias_gyro);

%%
%thresh_trials=[33 40 40 40 40 40 200 200 200 200 200 270];
thresh_trials=[33 40 40 40 40 40 40 40 40 100 65 60];
Kmat=[3  3  3  3  3  3  4 4 3 3 3 3];
breakpts=find_trial_breakpts(train_data1,thresh_trials,Kmat);
%%
num_code=4;
train_data=separate_trials(train_data1,breakpts,num_code);
train_data=find_states(train_data);
save('codebook.mat','train_data');
%%
load('codebook.mat');
lamda=initialize_lamda(train_data);
save('lamda.mat','lamda','bias_accel','bias_gyro','num_code');
%%
for i=1:numel(lamda)
    fprintf('dataset # %d\n',i);
    [lamda(i).A,lamda(i).B]=em_hmm(lamda(i).A,lamda(i).B,lamda(i).C,train_data(i));
end
%% Getting testing data
load('lamda.mat');
nameC={'frisbeeL','frisbeeR','shovelL','shovelR','swerveL','swerveR','dribble_shoot','figure8','jabs','lighter','lightsaber','windmill_dunk'};
for i=1:14
    if (i==12)
        continue;
    end
    fname=strcat('../data/test_set/',num2str(i),'.txt');
    %fname=strcat('../data/train_set/test_lighter_imu.txt');
    accel_x=[]; accel_y=[]; accel_z=[]; gyro_x=[]; gyro_y=[]; gyro_z=[];
    load_new_data(fname);
    test_raw_data=[accel_x'; accel_y'; accel_z'; gyro_x'; gyro_y'; gyro_z'];
    test_data=process_test_data(test_raw_data,bias_accel,bias_gyro,num_code);
    %subplot(2,1,1),plot(transpose(test_data.obs(1:3,:)));
    %subplot(2,1,2),plot(transpose(test_data.obs(4:6,:)));
    %pause;
    ll=zeros(1,numel(lamda));   
    for j=1:numel(lamda)
        [alpha, beta, alpha_norm_fact, ll(j)]=forward_backward(lamda(j).A,lamda(j).B,lamda(j).C,test_data.code);
    end
    [val,idx]=sort(ll,'ascend');
    fprintf ('\nGesture :: %d\n',i);
    fprintf ('#1 :: %s  with log-likelihood = %f\n',nameC{idx(1)},-ll(idx(1)));
    fprintf ('#2 :: %s  with log-likelihood = %f\n',nameC{idx(2)},-ll(idx(2)));
    fprintf ('#3 :: %s  with log-likelihood = %f\n',nameC{idx(3)},-ll(idx(3)));
end