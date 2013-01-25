function test_data=process_test_data(test_raw_data,bias_accel,bias_gyro,K)
    t_accel=accel2rotmat(test_raw_data(1:3,:),bias_accel);
    t_gyro=gyro2rotmat(test_raw_data(4:6,:),bias_gyro);
    imu=[t_accel;t_gyro];
    test_data=vector_quantization(imu,K);
end