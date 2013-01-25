%% Getting testing data
test_data=[];
load_new_data('../data/train_set/test_lighter_imu.txt');
test_data.imu=[accel_x'; accel_y'; accel_z'; gyro_x'; gyro_y'; gyro_z'];
%%
load ('gesture_pack.mat');
bias_accel = mean(calib_accel,2);
bias_gyro = mean(calib_gyro,2);
ref=3300;
sensitivity=300;
scale_factor=ref/(1023*sensitivity);
bias_accel(3)=bias_accel(3)-1/scale_factor;
t_accel=accel2rotmat(test_data.imu(1:3,:),bias_accel);
t_gyro=gyro2rotmat(test_data.imu(4:6,:),bias_gyro);
test_data.imu=[t_accel;t_gyro];
%%
load ('lamda.mat');
[mumean obs]=my_kmeans(test_data.imu,30,10);
ll=zeros(1,numel(lamda));
for i=1:numel(lamda)
    [alpha, beta, alpha_norm_fact, ll(i)]=forward_backward(lamda(i).A,lamda(i).B,lamda(i).C,obs);
end
nameC={'frisbeeL','frisbeeR','shovelL','shovelR','swerveL','swerveR','dribble_shoot','figure8','jabs','lighter','lightsaber','windmill_dunk'};
[val,idx]=sort(ll,'descend');
fprintf ('#1 :: %s  with log-likelihood = %f\n',nameC{idx(1)},ll(idx(1)));
fprintf ('#2 :: %s  with log-likelihood = %f\n',nameC{idx(2)},ll(idx(2)));
fprintf ('#3 :: %s  with log-likelihood = %f\n',nameC{idx(3)},ll(idx(3)));