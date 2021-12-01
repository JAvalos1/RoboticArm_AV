function[noap n]= GenerarTrayecto(MTHA, MTHB,curva)
if curva==1
    [noap n]=GenerarLinea(MTHA, MTHB);
end
end

function[noap n]= GenerarLinea(MTHA, MTHB)
%utilizando una ecuacion parametrica de la recta
%x=x0+alpha*(x1-x0)

pA=MTHA(1:3,4);
pB=MTHB(1:3,4);
Res=0.03;
if pA(1)>pB(1)
    x=pA(1):-Res:pB(1);
else
    x=pA(1):Res:pB(1);
end

n=length(x);
y=zeros(1,n);
z=zeros(1,n);
noap=zeros(4,4,n);
noap(:,:,1)=MTHA;
for i=2:n-1
    alpha=(x(i)-pA(1))/(pB(1)-pA(1));
    y(i)=pA(2)+alpha*(pB(2)-pA(1));
    z(i)=pA(3)+alpha*(pB(3)-pA(3));
    T=MTHA;
    T(1:3,4)=[x(i) y(i) z(i)];
    noap(:,:,i)=T;
end
noap(:,:,n)=MTHB;
end