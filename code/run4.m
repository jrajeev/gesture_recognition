%% Load Data
clear
clc
load ('gesture_pack.mat');

%% Process the data
%estimate bias
bias_accel = mean(calib_accel,2);
bias_gyro = mean(calib_gyro,2);
ref=3300;
sensitivity=300;
scale_factor=ref/(1023*sensitivity);
bias_accel(3)=bias_accel(3)-1/scale_factor;
%Convert the data
pdata=data;
for i=1:numel(data)
    [pdata{i}.accel pdata{i}.R_accel]=accel2rotmat(data{i}.accel,bias_accel);
    [pdata{i}.gyro pdata{i}.R_gyro]=gyro2rotmat(data{i}.gyro,bias_gyro);
    pdata{i}.imu=[pdata{i}.accel; pdata{i}.gyro];
end
save('processed_gesture_pack.mat','pdata','bias_accel','bias_gyro');

%% Plot data
for num=1:numel(pdata)
%Accelerometer
subplot(2,1,1),plot(1:size(pdata{num}.accel,2),pdata{num}.accel(1,:),'r');
hold on;
subplot(2,1,1),plot(1:size(pdata{num}.accel,2),pdata{num}.accel(2,:),'g');
hold on;
subplot(2,1,1),plot(1:size(pdata{num}.accel,2),pdata{num}.accel(3,:),'b');
title(['Accelerometer Plot for ',pdata{num}.name,' dataset']);
hold off;
%fname=strcat('../plots/',pdata{num}.name,'_accelerometer_plot.jpg');
%print ('-djpeg','-r72',fname);

%Gyrometer
subplot(2,1,2),plot(1:size(pdata{num}.gyro,2),pdata{num}.gyro(1,:),'r');
hold on;
subplot(2,1,2),plot(1:size(pdata{num}.gyro,2),pdata{num}.gyro(2,:),'g');
hold on;
subplot(2,1,2),plot(1:size(pdata{num}.gyro,2),pdata{num}.gyro(3,:),'b');
title(['Gyroscope Plot for ',pdata{num}.name,' dataset']);
hold off;
%fname=strcat('../plots/',pdata{num}.name,'_gyroscope_plot.jpg');
%print ('-djpeg', '-r72',fname);
fname=strcat('../plots/',pdata{num}.name,'_plot.jpg');
print ('-djpeg', '-r72',fname);
pause(0.5);
end
