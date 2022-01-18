function q=deg(x)
[xi xj]=size(x);
q=zeros(xi,xj);
for i=1:xi
    for j=1:xj
        q(i,j)=x(i,j)*180/pi;
    end
end
end