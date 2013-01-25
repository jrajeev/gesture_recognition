function n_codebook=find_trials(codebook)
    % Prune 10% starting and ending values
    for i=1:numel(codebook)
        szdata=numel(codebook{i}.cluster_id);
        thresh_prune=floor(0.1*szdata);
        range=thresh_prune:szdata-1;
        data=codebook{i}.cluster_id(range);
        for j=thresh_trial:numel(data)-thresh_trial
            %normalize the diff overlapping part
            data_diff=data(1:numel(data)-j) - data(j:numel(data));
            data_diff=diff/numel(diff);
        end
    end
end