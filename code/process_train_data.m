function [train_data]=process_train_data(train_raw_data,bias_accel,bias_gyro)
    train_data=train_raw_data;
    for i=1:numel(train_raw_data)
        [train_data(i).accel train_data(i).R_accel]=accel2rotmat(train_raw_data(i).accel,bias_accel);
        [train_data(i).gyro train_data(i).R_gyro]=gyro2rotmat(train_raw_data(i).gyro,bias_gyro);
        train_data(i).imu=[train_data(i).accel; train_data(i).gyro];
    end
    
    % Generate Plots
    %for num=1:numel(train_data)
        %Accelerometer
    %    subplot(2,1,1),plot(1:size(train_data(num).accel,2),train_data(num).accel(1,:),'r');
    %    hold on;
    %    subplot(2,1,1),plot(1:size(train_data(num).accel,2),train_data(num).accel(2,:),'g');
    %    hold on;
    %    subplot(2,1,1),plot(1:size(train_data(num).accel,2),train_data(num).accel(3,:),'b');
    %    title(['Accelerometer Plot for ',train_data(num).name,' dataset']);
    %    hold off;
        
        %Gyrometer
    %    subplot(2,1,2),plot(1:size(train_data(num).gyro,2),train_data(num).gyro(1,:),'r');
    %    hold on;
    %    subplot(2,1,2),plot(1:size(train_data(num).gyro,2),train_data(num).gyro(2,:),'g');
    %    hold on;
    %    subplot(2,1,2),plot(1:size(train_data(num).gyro,2),train_data(num).gyro(3,:),'b');
    %    title(['Gyroscope Plot for ',train_data(num).name,' dataset']);
    %    hold off;
        
    %    fname=['../plots/',train_data(num).name,'_plot.jpg'];
    %    print ('-djpeg', '-r72',fname);
    %    pause(0.5);
    %end
end