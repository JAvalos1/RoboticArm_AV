%% Primeros 3 eslabones
%Calulo de las variables necesarias
Pm=P-a6*aa;  %valores dados de P, vector aa
Pmx=Pm(1);  %Matriz noap dada?
Pmy=Pm(2);
Pmz=Pm(3);
r=sqrt(Pmy^2+Pmx^2);
BP=sqrt((Pmz-a1)^2+r^2);
CP=sqrt(a4^2+a5^2);
%Calculo de q1
q1=-atan(Pmy/Pmx);
%Calculo de q2
q2=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((Pmz-a1)/r);
%Calculo de q3
q3=pi-atan(a5/a4)-acos((a3^2+CP^2-BP^2)/(2*a3*CP));

%% Ultimos 3 eslabones
%Siendo MTH la matriz de transformacion T (noap)
%se debe cumplir inv(Tbase*A1*A2*A3)*MTH=A4*A5*A6
%Calculo de Tbase
Tbase=[rotx(pi) [1 0 0]';0 0 0 1];
%Calculo de A1
c1=cos(q1);
s1=sin(q1);
A1=[c1  0  s1  a2*c1;s1  0  -c1  a2*s1;0  1  0  -a1;0  0  0  1];
%Calculo de A2
c2=cos(q2);
s2=sin(q2);
A2=[s2  -c2  0  a3*s2;-c2  -s2  0  -a3*s2;0  0  -1  0;0  0  0  1];
%Calculo de A3
c3=cos(q3);
s3=sin(q3);
A3=[c3  0  -s3  a4*c3;s3  0  c3  a4*s3;0  -1  0  0;0  0  0  1];
%Calculo del producto
Tprima=(Tbase*A1*A2*A3)\MTH;
%Finalmente para los ultimos 3 eslabones
q4=atan(Tprima(2,3)/Tprima(1,3));
q5=acos(-Tprima(3,3));
q6=atan(Tprima(3,2)/Tprima(3,1));