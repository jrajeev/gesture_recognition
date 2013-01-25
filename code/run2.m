%%
clear all;
load_new_data('../gestures/frisbeeR_imu.txt');
imu_t_raw = imu_t;
load_new_data('../gestures/frisbeeR_rpy.txt');
imu_t_filtered = imu_t;
fidw = fopen('../gestures/frisbeeL.txt','w');

imu = 1;
rpy = 1;
tot = 1;
while imu<=numel(imu_t_raw)
fprintf(fidw,'[%d] accel = (%d %d %d) gyro = (%d %d %d)\n', ...
tot, accel_x(imu), accel_y(imu), accel_z(imu), ...
gyro_x(imu), gyro_y(imu), gyro_z(imu) ...
);
tot = tot+1;
while( rpy<=numel(imu_t_filtered) && imu_t_raw(imu) > imu_t_filtered(rpy) )
fprintf(fidw,'[%d] rpy = (%d %d %d)\n', ...
tot, roll(rpy), pitch(rpy), yaw(rpy) ...
);
rpy = rpy+1;
tot = tot+1;
end
imu = imu + 1;
end
fclose(fidw);