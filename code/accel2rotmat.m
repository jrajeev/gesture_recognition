function [Ap R]=accel2rotmat(Ar,bias)
    ref=3300;
    sensitivity=300;
    scale_factor=ref/(1023*sensitivity);
    Ap=bsxfun(@minus,Ar,bias);
    Ap=Ap*scale_factor;
    Ap(1:2,:)=-Ap(1:2,:);
    tmp=sqrt(sum(Ap.*Ap));
    Ap=bsxfun(@rdivide,Ap,tmp);
    st=Ap(1,:); ct=sqrt(1-Ap(1,:).*Ap(1,:));
    tmp=sqrt(Ap(2,:).*Ap(2,:) + Ap(3,:).*Ap(3,:));
    ss=Ap(2,:)./tmp; cs=Ap(3,:)./tmp;
    R=zeros(3,3,size(st,2));
    R(1,1,:)=ct; R(1,3,:)=-1*st;
    R(2,1,:)=st.*ss; R(2,2,:)=cs; R(2,3,:)=ct.*ss;
    R(3,1,:)=st.*cs; R(3,2,:)=-ss; R(3,3,:)=ct.*cs;
end