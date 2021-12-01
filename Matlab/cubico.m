
function res = cubico(r,q,puntos,T)

   [n,p] = size(q);
    
    x =0:T:T*(p-1);
    xx = 0:(T/(puntos+1)):T*(p-1);
    for i =1:n
        y = q(i,:);
        qinter(:,i) = spline(x,y,xx)';
    end
    
    res = qinter;
  
end


    
    