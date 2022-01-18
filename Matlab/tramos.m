
function [res] = tramos(r,q,T)


    [n,p ] = size(q);

   
    mi = p +(p-1)*5;
    qinter=zeros(mi,n);
    k = 1;
    deltaT = T/6;
     for i=1:6:mi
       qinter(i,:) = q(:,k);
       if(i<mi)
           %primer tramo (interpolador cubico)
           y = [q(:,k)  q(:,k+1)];
           x = 0:deltaT*6:deltaT*6;
           xx = 0:deltaT:deltaT*6;
           aux = zeros(1,6);
           au = zeros(7,6);
           for j=1:6
               au(:,j) =  spline(x,y(j,:),xx)';
               aux(j) = au(2,j);
           end
           qinter(i+1,:) = aux;
           qinter(i+2,:) = au(3,:);
           %segundo tramo (interpolador lineal)
           qinter(i+3,:) = (deltaT/(deltaT*2))*(au(5,:)-au(3,:)) + au(3,:);
           qinter(i+4,:) = au(5,:);
           %tercer tramo (interpolador cubico)
           qinter(i+5,:) = au(6,:);  
       end
       k = k+1;
     end
     res = qinter;
end

       
           