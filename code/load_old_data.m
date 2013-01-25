function [bias_accel, bias_gyro, train_old_data]=load_old_data()
    calib=[];
    data=[];
    fname={'dribble_shoot','figure8','jabs','lighter','lightsaber','windmill_dunk'};
    for i=1:numel(fname)
        fin=fopen(['../data/train_set/old_data/',fname{i},'.txt']);
        tline=fgetl(fin);
        dataset_cnt=0;
        line_cnt=0;
        while (ischar(tline))
            line_cnt=line_cnt+1;
            if (numel(tline)==0)
                dataset_cnt=dataset_cnt+1;
                fprintf ('Loading trial %d of dataset # %d : %s ...\n',dataset_cnt,i,fname{i});
                calib_cnt=0;
                data_cnt=0;
            elseif (tline(2)=='0')
                calib_cnt=calib_cnt+1;
                tmp=sscanf(tline,'[0] accel = (%d %d %d)   gyro = (%d %d %d)');
                calib{dataset_cnt}.accel(:,calib_cnt)=tmp(1:3);
                calib{dataset_cnt}.gyro(:,calib_cnt)=tmp(4:6);
            elseif (tline(2)~='0')        
                data_cnt=data_cnt+1;
                tmp=sscanf(tline,'[%d] rpy = (%d %d %d)');
                data{dataset_cnt}.rpy(:,data_cnt)=tmp(2:4);
                line_cnt=line_cnt+1;
                tline=fgetl(fin);
                if (numel(tline)==0 || ~ischar(tline))
                    continue;
                end
                tmp=sscanf(tline,'[%d] accel = (%d %d %d)   gyro = (%d %d %d)');
                data{dataset_cnt}.accel(:,data_cnt)=tmp(2:4);
                data{dataset_cnt}.gyro(:,data_cnt)=tmp(5:7);

            end
            tline=fgetl(fin);
        end
        train_old_data{i}.name=fname{i};
        train_old_data{i}.calib=calib;
        train_old_data{i}.data=data;
    end
    [bias_accel bias_gyro]=est_bias(train_old_data);
    ref=3300;
    sensitivity=300;
    scale_factor=ref/(1023*sensitivity);
    bias_accel(3)=bias_accel(3)-1/scale_factor;
end