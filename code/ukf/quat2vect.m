function v=quat2vect(q)
    v=bsxfun(@rdivide,q(2:4,:),sqrt(1-q(1,:).*q(1,:)));
    v(isnan(v))=0;
end