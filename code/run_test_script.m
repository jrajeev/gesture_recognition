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