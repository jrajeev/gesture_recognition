%% Load datas
clear
clc
%loading vicon data
load('../data/viconRot2.mat');
tsvicon=ts;
%loading imu data
load('../data/imuRaw2.mat');
tsimu=ts;
%loading cam data
load('../data/cam2.mat');
tscam=ts;

%% Synchronize time stamps
tsimu_cam=zeros(size(tsimu));
tsimu_vicon=zeros(size(tsimu));
tscam_imu=zeros(size(tscam));
tsvicon_imu=zeros(size(tsvicon));
tsvicon_cam=zeros(size(tsvicon));
tscam_vicon=zeros(size(tscam));
for i=1:numel(tscam)
    [val, idx]=min(abs(tscam(i)-tsimu));
    tsimu_cam(idx)=i;
    tscam_imu(i)=idx;
end
for i=1:numel(tsvicon)
    [val, idx]=min(abs(tsvicon(i)-tsimu));
    tsimu_vicon(idx)=i;
    tsvicon_imu(i)=idx;
end
for i=1:numel(tscam)
    [val, idx]=min(abs(tscam(i)-tsvicon));
    tsvicon_cam(idx)=i;
    tscam_vicon(i)=idx;
end
%% Convert data to states and observations
bias_accel=[510.79; 501; 510.13];
[accel,R_accel]=accel2rotmat(vals(1:3,:),bias_accel);
bias_gyro=[369.66; 373.63; 375.2];
[gyro,R_gyro]=gyro2rotmat(vals(4:6,:),bias_gyro);

%% Unscented Kalman Filter - 4 states
P=diag(rand(1,3));
Q=diag([0.2 0.2 0.2]);
R=diag([1 1 1]);
[q_fin, R_ukf]=ukf_4state(accel,gyro,P,Q,R);

%% Plot the results & error metric
for i=1000:10:4000%numel(tsvicon)
    if (abs(tsimu(tsvicon_imu(i))-tsvicon(i))<0.1)
        result_plot(R_ukf(:,:,tsvicon_imu(i)),rots(:,:,i),R_accel(:,:,tsvicon_imu(i)),R_gyro(:,:,tsvicon_imu(i)),i);
    end
end

%% Mosaic Generation
mosaic=zeros(2000,2000,3);
%fig=figure;
%aviobj=avifile('mosaic_video1','fps',10);
for i=1:numel(tscam)
    if (abs(tscam(i)-tsimu(tscam_imu(i)))<0.1)
    [angz,angy,angx]=dcm2angle(R_ukf(:,:,tscam_imu(i)));
    I=cam(:,:,:,i);
    I=double(imrotate(I,angx*180/pi));
    shiftr=250*tan(-angy);
    shiftc=250*angz;
    shiftr_std=1000-floor(size(I,1)/2);
    shiftc_std=1000-floor(size(I,2)/2);
    sr=floor(shiftr_std+shiftr);
    sc=floor(shiftc_std+shiftc);
    wtmatI=(I>0);
    if (sr>=1 && sr<=size(mosaic,1)-size(I,1)+1 && sc>=1 && sc<=size(mosaic,2)-size(I,2)+1)
        mosaic(sr:sr+size(I,1)-1,sc:sc+size(I,2)-1,:)=uint8(((1-wtmatI).*mosaic(sr:sr+size(I,1)-1,sc:sc+size(I,2)-1,:)+wtmatI.*I(:,:,:)));
        imshow(uint8(mosaic));
        title(['iterations',num2str(i),' | timestamp difference',num2str(tscam(i)-tsimu(tscam_imu(i)))])
        %g=getframe(fig);
        %aviobj=addframe(aviobj,g);
        pause (0.01);
    end
    end
end
%aviobj=close(aviobj);
%clear aviobj;
%% Smooth the image
G=fspecial('gaussian');
mosaic(:,:,1)=conv2(mosaic(:,:,1),G,'same');
mosaic(:,:,2)=conv2(mosaic(:,:,2),G,'same');
mosaic(:,:,3)=conv2(mosaic(:,:,3),G,'same');
img_idx=find(mosaic);
[row,col,ch]=ind2sub(size(mosaic),img_idx);
xxmin=min(row); xxmax=max(row);
yymin=min(col); yymax=max(col);
zzmin=min(ch); zzmax=max(ch);
figure,imshow(uint8(mosaic(xxmin:xxmax,yymin:yymax,:)));