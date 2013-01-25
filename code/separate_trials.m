function train_data_sep=separate_trials(train_data,breakpts,K)
    fprintf('In separate_trials.m \n');
    train_data_sep=[];
    tt=CTimeleft(numel(train_data));
    for i=1:numel(train_data)
        tt.timeleft();
        % Quantize the imu readings to codes
        codebook=vector_quantization(train_data(i).imu,K);
        train_data_sep(i).class=train_data(i).class;
        train_data_sep(i).name=train_data(i).name;
        train_data_sep(i).num_code=codebook.num_code;
        for j=1:numel(breakpts(i).st)
            train_data_sep(i).trial(j).code=codebook.code(breakpts(i).st(j):breakpts(i).fin(j));
            train_data_sep(i).trial(j).obs=codebook.obs(:,breakpts(i).st(j):breakpts(i).fin(j));
        end
    end
end
