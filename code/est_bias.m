function [bias_accel, bias_gyro]=est_bias(gestures)
    tmp_accel2=zeros(3,numel(gestures));
    tmp_gyro2=zeros(3,numel(gestures));
    for i=1:numel(gestures)
        tmp_accel1=zeros(3,numel(gestures{i}.calib));
        tmp_gyro1=zeros(3,numel(gestures{i}.calib));
        for j=1:numel(gestures{i}.calib)
            tmp_accel1(:,j)=mean(gestures{i}.calib{j}.accel,2);
            tmp_gyro1(:,j)=mean(gestures{i}.calib{j}.gyro,2);
        end
        tmp_accel2(:,i)=mean(tmp_accel1,2);
        tmp_gyro2(:,i)=mean(tmp_gyro1,2);
    end
    bias_accel=mean(tmp_accel2,2);
    bias_gyro=mean(tmp_gyro2,2);
end