function train_raw_data=merge_data()
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
end