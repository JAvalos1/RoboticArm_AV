
function res = lineal(r,q,puntos,T)
    [n, p] = size(q);
    deltaT = T/(puntos+1);

    mi = p +(p-1)*puntos;
    qinter=zeros(mi,n);
    k=1;
    for i=1:(puntos+1):mi
       qinter(i,:) = q(:,k);
       if (i<mi)
          for j=1:puntos
            qinter(i+j,:) = ((deltaT*j)/T)*(q(:,k+1)-q(:,k)) + q(:,k);
          end
       end
       k = k +1;
    end
    res = qinter;
end

