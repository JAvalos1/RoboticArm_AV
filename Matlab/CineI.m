% #-----------------------------------------------------------------------#
% #Definicion del objeto Robot para Robotics Toolbox Version 10.4
% #Modelo del robot: Racer 3
% #Marca del robot: Comau
% #Datos del Autor.
% #->Nombres: Julio Fabian
% #->Apellidos: Avalos Peralta
% #->C.I: 3877117
% #->Correo: javalos@fiuna.edu.py
% #
% #q=CineI(robot,MTH)
% #Robot: Objeto robot
% #q: vector de valores de las variables articulares
% #MTH: Matriz de Transformacion Homogenea para los valores de q
% #-----------------------------------------------------------------------#
function [q]=CineI(robot,MTH)
global d_dh a_dh alpha_dh offset_dh qlim pm MTH qp robot
n=MTH(1:3,1);
o=MTH(1:3,2);
a=MTH(1:3,3);
p=MTH(1:3,4);

d_dh=robot.d;
a_dh=robot.a;
alpha_dh=robot.alpha;
offset_dh=robot.offset;
qlim=robot.qlim;

%base=[rotx(pi) [0 0 0]';0 0 0 1];
%tool=[rotz(pi) [0 0 0]';0 0 0 1];

a1=d_dh(1);
a2=a_dh(1);
a3=abs(a_dh(2));
a4=a_dh(3);
a5=abs(d_dh(5));

%*** Obtencion de Pm
pm=p-a5*a;

qp=[pi/2 -pi/2 pi -pi 3/2*pi -3/2*pi 2*pi -2*pi];
%--------------Obtenci�n de q1---------------------------------------------
%*** obtencion de q1 calculado
q1c=atan(pm(2)/pm(1));   %Ecuaci�n 3.1.1

%*** vector de posibles soluciones de q1;
q1=[q1c -q1c qp+q1c*ones(1,length(qp)) qp-q1c*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q1,qlim(1,:));
if isempty(qaux)
    error('no existe solucion para q1')
else
    q1=qaux;
end

%--------------Obtenci�n de q3---------------------------------------------
r=sqrt(pm(2)^2+pm(1)^2);

for j=1:2

if j==1
    cosq3=((r-a2)^2+(pm(3)-a1)^2-a3^2-a4^2)/(2*a3*a4);
else
    cosq3=((-r-a2)^2+(pm(3)-a1)^2-a3^2-a4^2)/(2*a3*a4);
end

%% Solucion 1
q3c1=atan(sqrt(1-cosq3^2)/cosq3);    %Ecuacion 3.1.13

%*** vector de posibles soluciones de q3;
q31=[q3c1 -q3c1 qp+q3c1*ones(1,length(qp)) qp-q3c1*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q31,qlim(3,:));
if isempty(qaux)
    error('no existe solucion para q3')
else
    q31=qaux;
end

%--------------Obtenci�n de q2---------------------------------------------
fi=atan(abs(pm(3)-a1)/abs(r-a2));      %Ecuacion 3.1.10
fe=atan((a4*sin(q3c1))/(a3+a4*cos(q3c1)));
if pm(3)<a1 || pm(3)<0
    q2c1=pi/2+fi+fe;                    %Ecuacion 3.1.11
else
    q2c1=pi/2-fi+fe;                    %Ecuacion 3.1.11
end

%q2c=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((pm(3)-a1)/r);

%*** vector de posibles soluciones de q2;
q21=[q2c1 -q2c1 qp+q2c1*ones(1,length(qp)) qp-q2c1*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q21,qlim(2,:));
if isempty(qaux)
    error('no existe solucion para q2')
else
    q21=qaux;
end

%% Solucion 2
q3c2=atan(-sqrt(1-cosq3^2)/cosq3);    %Ecuacion 3.1.13

%*** vector de posibles soluciones de q3;
q32=[q3c2 -q3c2 qp+q3c2*ones(1,length(qp)) qp-q3c2*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q32,qlim(3,:));
if isempty(qaux)
    error('no existe solucion para q3')
else
    q32=qaux;
end

%--------------Obtenci�n de q2---------------------------------------------
fi=atan(abs(pm(3)-a1)/abs(r-a2));      %Ecuacion 3.1.10
fe=atan((a4*sin(q3c2))/(a3+a4*cos(q3c2)));
if pm(3)<a1 || pm(3)<0
    q2c2=pi/2+fi+fe;                    %Ecuacion 3.1.11
else
    q2c2=pi/2-fi+fe;                    %Ecuacion 3.1.11
end

%q2c=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((pm(3)-a1)/r);

%*** vector de posibles soluciones de q2;
q22=[q2c2 -q2c2 qp+q2c2*ones(1,length(qp)) qp-q2c2*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q22,qlim(2,:));
if isempty(qaux)
    error('no existe solucion para q2')
else
    q22=qaux;
end

%% Solucion 3
q3c3=atan(sqrt(1-cosq3^2)/cosq3);    %Ecuacion 3.1.13

%*** vector de posibles soluciones de q3;
q33=[q3c3 -q3c3 qp+q3c3*ones(1,length(qp)) qp-q3c3*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q33,qlim(3,:));
if isempty(qaux)
    error('no existe solucion para q3')
else
    q33=qaux;
end

%--------------Obtenci�n de q2---------------------------------------------
fi=atan(abs(pm(3)-a1)/abs(-r-a2));      %Ecuacion 3.1.10
fe=atan((a4*sin(q3c3))/(a3+a4*cos(q3c3)));
if pm(3)<a1 || pm(3)<0
    q2c3=pi/2+fi+fe;                    %Ecuacion 3.1.11
else
    q2c3=pi/2-fi+fe;                    %Ecuacion 3.1.11
end

%q2c=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((pm(3)-a1)/r);

%*** vector de posibles soluciones de q2;
q23=[q2c3 -q2c3 qp+q2c3*ones(1,length(qp)) qp-q2c3*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q23,qlim(2,:));
if isempty(qaux)
    error('no existe solucion para q2')
else
    q23=qaux;
end

%% Solucion 4
q3c4=atan(-sqrt(1-cosq3^2)/cosq3);    %Ecuacion 3.1.13

%*** vector de posibles soluciones de q3;
q34=[q3c4 -q3c4 qp+q3c4*ones(1,length(qp)) qp-q3c4*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q34,qlim(3,:));
if isempty(qaux)
    error('no existe solucion para q3')
else
    q34=qaux;
end

%--------------Obtenci�n de q2---------------------------------------------
fi=atan(abs(pm(3)-a1)/abs(-r-a2));      %Ecuacion 3.1.10
fe=atan((a4*sin(q3c4))/(a3+a4*cos(q3c4)));
if pm(3)<a1 || pm(3)<0
    q2c4=pi/2+fi+fe;                    %Ecuacion 3.1.11
else
    q2c4=pi/2-fi+fe;                    %Ecuacion 3.1.11
end

%q2c=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((pm(3)-a1)/r);

%*** vector de posibles soluciones de q2;
q24=[q2c4 -q2c4 qp+q2c4*ones(1,length(qp)) qp-q2c4*ones(1,length(qp))];

%*** eliminaci�n de valores fuera de los l�metes de las articulaciones
qaux=evalqlim(q24,qlim(2,:));
if isempty(qaux)
    error('no existe solucion para q2')
else
    q24=qaux;
end

%%Verificar si las soluciones posibles son soluciones reales

q=[];
i=1;

q0=soluciones(q1,q21,q31);
if isempty(q0)
    fprintf('Solucion 1 no satisfactoria');
else
    q0=eliminarDobles(q0,n-1);
    q(i,:)=q0;
    i=i+1;
end

q2=soluciones(q1,q21,q32);
if isempty(q2)
    fprintf('Solucion 2 no satisfactoria');
else
    q2=eliminarDobles(q2,n-1);
    q(i,:)=q2;
    i=i+1;
end

q3=soluciones(q1,q21,q33);
if isempty(q3)
    fprintf('Solucion 3 no satisfactoria');
else
    q3=eliminarDobles(q3,n-1);
    q(i,:)=q3;
    i=i+1;
end

q4=soluciones(q1,q21,q34);
if isempty(q4)
    fprintf('Solucion 4 no satisfactoria');
else
    q4=eliminarDobles(q4,n-1);
    q(i,:)=q4;
    i=i+1;
end

q5=soluciones(q1,q22,q31);
if isempty(q5)
    fprintf('Solucion 5 no satisfactoria');
else
    q5=eliminarDobles(q5,n-1);
    q(i,:)=q5;
    i=i+1;
end

q6=soluciones(q1,q22,q32);
if isempty(q6)
    fprintf('Solucion 6 no satisfactoria');
else
    q6=eliminarDobles(q6,n-1);
    q(i,:)=q6;
    i=i+1;
end

q7=soluciones(q1,q22,q33);
if isempty(q7)
    fprintf('Solucion 7 no satisfactoria');
else
    q7=eliminarDobles(q7,n-1);
    q(i,:)=q7;
    i=i+1;
end

q8=soluciones(q1,q22,q34);
if isempty(q8)
    fprintf('Solucion 8 no satisfactoria');
else
    q8=eliminarDobles(q8,n-1);
    q(i,:)=q8;
    i=i+1;
end

q9=soluciones(q1,q23,q31);
if isempty(q9)
    fprintf('Solucion 1 no satisfactoria');
else
    q9=eliminarDobles(q9,n-1);
    q(i,:)=q9;
    i=i+1;
end

q10=soluciones(q1,q23,q32);
if isempty(q10)
    fprintf('Solucion 2 no satisfactoria');
else
    q10=eliminarDobles(q10,n-1);
    q(i,:)=q10;
    i=i+1;
end

q11=soluciones(q1,q23,q33);
if isempty(q11)
    fprintf('Solucion 3 no satisfactoria');
else
    q11=eliminarDobles(q11,n-1);
    q(i,:)=q11;
    i=i+1;
end

q12=soluciones(q1,q23,q34);
if isempty(q12)
    fprintf('Solucion 4 no satisfactoria');
else
    q12=eliminarDobles(q12,n-1);
    q(i,:)=q12;
    i=i+1;
end

q13=soluciones(q1,q24,q31);
if isempty(q13)
    fprintf('Solucion 5 no satisfactoria');
else
    q13=eliminarDobles(q13,n-1);
    q(i,:)=q13;
    i=i+1;
end

q14=soluciones(q1,q24,q32);
if isempty(q14)
    fprintf('Solucion 6 no satisfactoria');
else
    q14=eliminarDobles(q14,n-1);
    q(i,:)=q14;
    i=i+1;
end

q15=soluciones(q1,q24,q33);
if isempty(q15)
    fprintf('Solucion 7 no satisfactoria');
else
    q15=eliminarDobles(q15,n-1);
    q(i,:)=q15;
    i=i+1;
end

q16=soluciones(q1,q24,q34);
if isempty(q16)
    fprintf('Solucion 8 no satisfactoria');
else
    q16=eliminarDobles(q16,n-1);
    q(i,:)=q16;
    i=i+1;
end

if not(isempty(q))
    break;
end

end
end

function q=soluciones(q1,q2,q3)
global d_dh a_dh alpha_dh offset_dh qlim pm MTH qp robot
q=[];
n=1;
for i=1:length(q1)
    for j=1:length(q2)
        for k=1:length(q3)
            %DH(teta, d, a, alfa)
            A03=...
                DH(q1(i)+offset_dh(1),d_dh(1),a_dh(1),alpha_dh(1))*...
                DH(q2(j)+offset_dh(2),d_dh(2),a_dh(2),alpha_dh(2))*...
                DH(q3(k)+offset_dh(3),d_dh(3),a_dh(3),alpha_dh(3));
            %A34=DH(0+offset_dh(4),d_dh(4),a_dh(4),alpha_dh(4));
            A04=A03;%*A34;
%              pos=deg([q1(i) q2(j) q3(k)])
            if isequal(round(A04(1:3,4),3),round(pm,3))

%--------------Obtenci�n de q4 q5 -----------------------------------------
                Raux=(A03(1:3,1:3))\MTH(1:3,1:3);        %Ecuacion 3.3.1
                q5p=atan(Raux(3,1)/Raux(3,2));                     %Ecuacion 3.3.3
                
                q4p=atan(Raux(2,3)/Raux(1,3));         %Ecuacion 3.3.5
                


                  q5=[q5p -q5p qp+q5p*ones(1,length(qp)) ...
                      qp-q5p*ones(1,length(qp))];


                  q4=[q4p -q4p qp+q4p*ones(1,length(qp)) ...
                      qp-q4p*ones(1,length(qp))];

                qaux=evalqlim(q5,qlim(5,:));
                if isempty(qaux)
                    break;
                else
                    q5=qaux;
                end

                qaux=evalqlim(q4,qlim(4,:));
                if isempty(qaux)
                    break;
                else
                    q4=qaux;
                end

                for q4i=1:length(q4)
                    for q5i=1:length(q5)
                        %for q6i=1:length(q6)
                  %          if round(q5(q5i),3)==0
                   %             q4(q4i)=0;
                         %       q6(q6i)=acos(-dot(A03(1:3,1),MTH(1:3,1)));
                    %        end


%                               ar=deg([q1(i) q2(j) q3(k) q4(q4i) q5(q5i) q6(q6i)])

                           mth=CineD(robot,[q1(i) q2(j) q3(k) q4(q4i) ...
                                q5(q5i)]);% q6(q6i)]);

                            if isequal(round(mth,6), round(MTH,6))
                                q(n,:)=[q1(i) q2(j) q3(k) q4(q4i) ...
                                q5(q5i)];% q6(q6i)];
                                n=n+1;
                            end
                        %end
                    end
                end

            end
        end
    end
end
end


function qaux=evalqlim(q,qlim)
%qlim vector de 1x2
qaux=[];
k=1;
for i=1:length(q)
    if q(i)>qlim(1,1) && q(i)<qlim(1,2)
        band=1;
        if k>1
            for j=2:k

                if k>1 && round(q(i),3) == round(qaux(j-1),3)
                    band=0;
                    break;
                end
            end
        end
        if band
            qaux(k)=q(i);
            k=k+1;
        end
    end
end
end


function qs=eliminarDobles(q,n)
qs(1,:)=q(1,:);
j=1;
band=0;
     for i=2:n
         band=1;
         for k=1:j
             if isequal(round(q(i,:),3),round(qs(k,:),3))
                 band=0;
                 break;
             end
         end
         if band==1
             j=j+1;
             qs(j,:)=q(i,:);
         end
     end
end