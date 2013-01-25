function gestures_p=process_rawdata(gestures,bias_accel,bias_gyro)
    for i=1:numel(gestures)
        gestures_p{i}.name=gestures{i}.name;
        for j=1:numel(gestures{i}.data)
            [gestures_p{i}.data{j}.accel gestures_p{i}.data{j}.R_accel]=accel2rotmat(gestures{i}.data{j}.accel,bias_accel);
            [gestures_p{i}.data{j}.gyro gestures_p{i}.data{j}.R_gyro]=gyro2rotmat(gestures{i}.data{j}.gyro,bias_gyro);
            gestures_p{i}.data{j}.rpy =gestures{i}.data{j}.rpy;
            roll=gestures{i}.data{j}.rpy(1,:);
            pitch=gestures{i}.data{j}.rpy(2,:);
            yaw=gestures{i}.data{j}.rpy(3,:);
            gestures_p{i}.data{j}.R_vicon=angle2dcm(yaw,pitch,roll);
        end
    end
end