function [q_fin, R_ukf]=ukf_4state(accel,gyro,P,Q,R)
    del_t=1/100; %time step
    %states initialized from first accelerometer reading
    grad_desc_thresh=0.001;
    g=[0 0 0 1];
    R_ukf=zeros(3,3,size(accel,2));
    xcap=[1;0;0;0];
    q_fin=zeros(4,size(accel,2));
    for i=1:size(accel,2)
        % Quaternion sigma points
        fprintf('Timestep # %d\n',i);
        L=chol(P+Q);
        L1=L*sqrt(6); %n=3 sqrt(2n)
        L2=-L1;
        W=[L1 L2];
        X=vect2quat(W);
        
        %Process Model
        % Transformation of the sigma points
        omega=gyro(:,i);
        norm_factor=sqrt(sum(omega.*omega));
        alpha_del=norm_factor*del_t;
        e_del=omega/norm_factor;
        q_del=[cos(alpha_del/2); e_del*sin(alpha_del/2)];

        q_int=quatmultiply(xcap',X');
        qi=quatmultiply(q_int,q_del');
        qi=quatnormalize(qi);
        Y=qi';
        
        % Gradient descent for a priori mean computation
        q=xcap';
        iters=0;
        norm_e=1;
        while (norm_e>grad_desc_thresh &&  iters<50)
            e_quat=quatmultiply(qi,quatinv(q));
            e_vect=quat2vect(e_quat');
            e_mean=mean(e_vect,2);
            e_quat=vect2quat(e_mean);
            e_quat=e_quat';
            q=quatmultiply(e_quat,q);
            norm_e=sqrt(sum(e_mean.*e_mean));
            iters=iters+1;
            %fprintf('iteration # %d\n',iters);
        end
        fprintf('gradient descent algo took  %d  iterations and norm = %d\n',iters,norm_e);
        xcap_=q';
        
        % Computation of a priori state vector covariance
        Wprime=e_vect;
        P_=cov(Wprime');
        
        % Measurement Estimate Covariance
        gprime=quatmultiply(Y',quatmultiply(g,quatinv(Y')));
        gvect=quat2vect(gprime'); 
        Z=gvect;
        z_=mean(Z,2);
        z_obs=accel(:,i);
        
        v=z_obs-z_;
        Pzz=cov(Z');
        Pvv=Pzz + R;

        % Cross Correlation Matrix
        tmp=bsxfun(@minus,Z,z_);
        tmp=tmp';
        Pxz=zeros(3,3);
        for j=1:size(W,2)
            Pxz=Pxz+(W(:,j)*tmp(j,:));
        end
        Pxz=Pxz/6;
        
        %Update equations
        K=Pxz*(Pvv^-1); % Kalman gain update
        xcap=transpose(quatmultiply(xcap_',transpose(vect2quat(K*v)))); % a posteriori estimate update
        %P=P_ - K*Pvv*K'; % State covariance update;
        P=P_;
        %Convert xcap to quaternion and then to rotation matrix
        q_fin(:,i)=xcap;
        R_ukf(:,:,i)=quat2dcm(transpose(q_fin(:,i)));
    end
end