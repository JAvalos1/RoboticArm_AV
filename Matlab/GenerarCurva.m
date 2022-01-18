function [noap,n]=GenerarCurva(curva,MTHA, MTHB,res)
%Funcion que realiza un recta ennte los puntos A y B o bien una
%circunferencia de centro en el punto medio entre A y B
%Considerando que A y B estan en un mismo plano, se usan las
%formulas de la recta en el plano.
A=MTHA(1:3,4);
B=MTHB(1:3,4);
if curva==2
    puntos=circunf(A,B,res);
else
    puntos=recta(A,B,res);
end
n=length(puntos);
noap=zeros(4,4,n);
for i=1:n
    noap(:,:,i)=[0 1 0 puntos(1,i);
                 0 0 1 puntos(2,i);
                 1 0 0 puntos(3,i);
                 0 0 0 1];
end
end

function cia=circunf(A,B,res)
AB=B-A;
ab=AB/norm(AB);
theta=acos(dot(ab,[0 1 0]));
C=(A+B)/2;
if B(3)<C(3)
    theta=-theta; 
end
T=[1 0 0 C(1);
    0 cos(theta) -sin(theta) C(2);
    0 sin(theta) cos(theta) C(3);
    0 0 0 1];
T1=T\eye(4,4);
A2=T1*[A;1];
B2=T1*[B;1];
r=norm(B2-A2);
dist=round(r/res);
y2=zeros(1,dist+1);
z2=zeros(1,dist+1);
cia=zeros(4,dist+1);
y2(1)=A2(2);
z2(1)=A2(3);
y2(dist+1)=B2(2);
z2(dist+1)=B2(3);
for i=2:dist
    y2(i)=y2(i-1)+res;
    z2(i)=sqrt(r^2/4-y2(i)^2);
end
for i=1:dist+1;
    cia(:,i)=T*[0 y2(i) z2(i) 1]';
end
end

function puntos=recta(A,B,res)
AB=B-A;
ab=AB/norm(AB);
theta=acos(dot(ab,[0 1 0]));
if B(3)<A(3)
    theta=-theta; 
end
T=[1 0 0 A(1);
    0 cos(theta) -sin(theta) A(2);
    0 sin(theta) cos(theta) A(3);
    0 0 0 1];
T1=T\eye(4,4);
A2=T1*[A;1];
B2=T1*[B;1];
dist=round(norm(B2-A2)/res);
puntos=zeros(4,dist+1);
y=zeros(1,dist+1);
y(1)=0;
puntos(:,1)=T*[0 A2(2) 0 1]';
for i=2:dist
    y(i)=y(i-1)+res;
    puntos(:,i)=T*[0 y(i) 0 1]';
end
puntos(:,i+1)=T*[0 B2(2) 0 1]';
end