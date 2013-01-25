function [gyro,R_gyro]=gyro2rotmat(Gr,bias)
    ref=3300;
    sensitivity=3.33*180/(pi);
    scale_factor=ref/(1023*sensitivity);
    Gp=bsxfun(@minus,Gr,bias);
    Gp=Gp*scale_factor;
    gyro=[Gp(2:3,:); Gp(1,:)];
    del_t=1/100;
    tmp=gyro*del_t;
    tmp=cumsum(tmp);
    R_gyro=angle2dcm(tmp(1,:),tmp(2,:),tmp(3,:),'XYZ');
end