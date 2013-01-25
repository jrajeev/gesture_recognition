function codebook=vector_quantization(imu, K)
    [mumean cluster_id]=my_kmeans(imu,K,10);
    %prune 5% end data
    sz=numel(cluster_id);
    %cluster_id=cluster_id(1:sz-floor(0.05*sz));
    codebook.num_code=K;
    codebook.code=cluster_id(1:sz-floor(0.05*sz));
    codebook.obs=imu(:,1:numel(codebook.code));
end