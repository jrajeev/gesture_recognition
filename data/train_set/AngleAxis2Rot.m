%Covert the Angle-axis rotation to a 3x3 Rotation matrix
%Alex Kushleyev, Upenn

function R = AngleAxis2Rot(u,v,w)  %u,v,w are x,y,z components of the vector of rotation

u2=u^2;
v2=v^2;
w2=w^2;

%L is the angle of rotation as well as magnitude of <u,v,w>
L = sqrt(u^2 + v^2 + w^2);
L2 = L^2;

R11 = (u2 + (v2+w2)*cos(L))/L2;
R21 = (u*v*(1-cos(L)) + w*L*sin(L))/L2;
R31 = (u*w*(1-cos(L))-v*L*sin(L))/L2;

R12 = (u*v*(1-cos(L)) - w*L*sin(L))/L2;
R22 = (v2+(u2+w2)*cos(L))/L2;
R32 = (v*w*(1-cos(L))+u*L*sin(L))/L2;

R13 = (u*w*(1-cos(L))+v*L*sin(L))/L2;
R23 = (v*w*(1-cos(L))-u*L*sin(L))/L2;
R33 = (w2+(u2+v2)*cos(L))/L2;

R= [R11 R12 R13; R21 R22 R23; R31 R32 R33];
