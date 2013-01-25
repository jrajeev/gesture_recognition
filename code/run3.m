%%
clear
clc
gestures_p=process_rawdata(gestures,bias_accel,bias_gyro);
%% For New Data Format
data=[];
nameC={'frisbeeL','frisbeeR','shovelL','shovelR','swerveL','swerveR','dribble_shoot','figure8','jabs','lighter','lightsaber','windmill_dunk'};
for i=1:6
    load_new_data(strcat('../gestures/',nameC{i},'_imu.txt'));
    data{i}.class=i;
    data{i}.name=nameC{i};
    data{i}.accel=[accel_x'; accel_y'; accel_z'];
    data{i}.gyro=[gyro_x'; gyro_y'; gyro_z'];
end

%% For Old Data Format
load('gestures.mat');
calib_accel=[];
calib_gyro=[];
for i=7:12
    data{i}.class=i;
    data{i}.name=nameC{i};
    tmpA=[];
    tmpG=[];
    for j=1:numel(gestures{i-6}.data)
        tmpA=[tmpA gestures{i-6}.data{j}.accel];
        tmpG=[tmpG gestures{i-6}.data{j}.gyro];
    end
    for j=1:numel(gestures{i-6}.calib)
        calib_accel=[calib_accel gestures{i-6}.calib{j}.accel];
        calib_gyro=[calib_gyro gestures{i-6}.calib{j}.gyro];
    end        
    data{i}.accel=tmpA;
    data{i}.gyro=tmpG;
end
save('gesture_pack.mat','data','calib_accel','calib_gyro');