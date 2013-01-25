function q=vect2quat(v)
    norm_factor=sqrt(sum(v(1:3,:).*v(1:3,:),1));
    alpha_v=norm_factor;
    e_v=bsxfun(@rdivide,v(1:3,:),norm_factor);
    e_v(isnan(e_v))=0;
    q=[cos(alpha_v/2); bsxfun(@times,e_v,sin(alpha_v/2))];
end