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
function q=CineI(robot,MTH)

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

a1=abs(d_dh(1));
a2=a_dh(1);
a3=a_dh(2);
a4=a_dh(3);
a5=abs(d_dh(4));
a6=abs(d_dh(6));

%*** Obtencion de Pm
pm=p-a6*a;

qp=[pi/2 -pi/2 pi -pi 3/2*pi -3/2*pi 2*pi -2*pi];
%--------------Obtención de q1---------------------------------------------
%*** obtencion de q1 calculado
q1c=atan(pm(2)/pm(1));   %Ecuación 3.1.1

%*** vector de posibles soluciones de q1;
q1=[q1c -q1c qp+q1c*ones(1,length(qp)) qp-q1c*ones(1,length(qp))];

%*** eliminación de valores fuera de los límetes de las articulaciones
qaux=evalqlim(q1,qlim(1,:));
if isempty(qaux)
    error('no existe solucion para q1')
else
    q1=qaux;
end

%--------------Obtención de q3---------------------------------------------
%r=(pm(1)^2+pm(2)^2)^(0.5);   %Ecuacion 3.1.2
%AB=sqrt(a1^2+a2^2);          %Ecuacion 3.1.3
%Pm=sqrt(pm(1)^2+pm(2)^2+pm(3)^2);      %Ecuacion 3.1.4
%***********************************************************************************************
% alfa=atan(a2/a1);            %Ecuacion 3.1.5
% beta=atan(abs(pm(3))/r);          %Ecuacion 3.1.6
% if pm(3)<0
%     BPm=sqrt((a1^2+a2^2)+(pm(1)^2+pm(2)^2+pm(3)^2)-2*AB*Pm*cos(pi/2-alfa+beta));  %Ecuacion 3.1.7
% elseif pm(3)>0 && beta>(pi/2-alfa)
%     BPm=sqrt((a1^2+a2^2)+(pm(1)^2+pm(2)^2+pm(3)^2)-2*AB*Pm*cos(pi/2+alfa-beta));  %Ecuacion 3.1.7
% elseif pm(3)>0 && beta<=(pi/2-alfa)
%     BPm=sqrt((a1^2+a2^2)+(pm(1)^2+pm(2)^2+pm(3)^2)-2*AB*Pm*cos(pi/2-alfa-beta));  %Ecuacion 3.1.7
% end
%***********************************************************************************************
r=sqrt(pm(2)^2+pm(1)^2);
BPm=sqrt((pm(3)-a1)^2+(r-a2)^2);  %Ecuacion 3.1.7a
CPm=sqrt(a4^2+a5^2);         %Ecuacion 3.1.8
gamma=acos((CPm^2+a3^2-BPm^2)/(2*a3*CPm));    %Ecuacion 3.1.12
%r=sqrt(pm(2)^2+pm(1)^2);
%BP=sqrt((pm(3)-a1)^2+r^2);
%CP=sqrt(a4^2+a5^2);

%*** obtencion de q3 calculado
%q3c=pi-atan(a5/a4)-acos((a3^2+CP^2-BP^2)/(2*a3*CP));
q3c=atan(a5/a4)-pi+gamma;    %Ecuacion 3.1.13

%*** vector de posibles soluciones de q3;
q3=[q3c -q3c qp+q3c*ones(1,length(qp)) qp-q3c*ones(1,length(qp))];

%*** eliminación de valores fuera de los límetes de las articulaciones
qaux=evalqlim(q3,qlim(3,:));
if isempty(qaux)
    error('no existe solucion para q3')
else
    q3=qaux;
end

%--------------Obtención de q2---------------------------------------------
fi=atan(abs(pm(3)-a1)/abs(r-a2));      %Ecuacion 3.1.10
fe=acos((a3^2+BPm^2-CPm^2)/(2*a3*BPm));
if pm(3)<a1 || pm(3)<0
    q2c=pi/2+fi-fe;                    %Ecuacion 3.1.11
else
    q2c=pi/2-fi-fe;                    %Ecuacion 3.1.11
end

%q2c=acos((BP^2+a3^2-CP^2)/(2*a3*BP))-pi/2+atan((pm(3)-a1)/r);

%*** vector de posibles soluciones de q2;
q2=[q2c -q2c qp+q2c*ones(1,length(qp)) qp-q2c*ones(1,length(qp))];

%*** eliminación de valores fuera de los límetes de las articulaciones
qaux=evalqlim(q2,qlim(2,:));
if isempty(qaux)
    error('no existe solucion para q2')
else
    q2=qaux;
end

%%Verificar si las soluciones posibles son soluciones reales

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
            A34=DH(0+offset_dh(4),d_dh(4),a_dh(4),alpha_dh(4));
            A04=A03*A34;
%              pos=deg([q1(i) q2(j) q3(k)])
            if isequal(round(A04(1:3,4),3),round(pm,3))

%--------------Obtención de q4 q5 q6---------------------------------------
                Raux=(A03(1:3,1:3))\MTH(1:3,1:3);        %Ecuacion 3.3.1
                q5p=acos(-Raux(3,3));                     %Ecuacion 3.3.3
                if round(q5p,3)==0
                    q4p=0;
                    q6p=acos(-dot(A03(1:3,1),MTH(1:3,1)));
                else
                    q4p=atan(Raux(2,3)/Raux(1,3));          %Ecuacion 3.3.4
                    q6p=atan(Raux(3,2)/Raux(3,1));         %Ecuacion 3.3.5

                end


                  q5=[q5p -q5p qp+q5p*ones(1,length(qp)) ...
                      qp-q5p*ones(1,length(qp))];


                  q4=[q4p -q4p qp+q4p*ones(1,length(qp)) ...
                      qp-q4p*ones(1,length(qp))];

                  q6=[q6p -q6p qp+q6p*ones(1,length(qp)) ...
                      qp-q6p*ones(1,length(qp))];

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

                qaux=evalqlim(q6,qlim(6,:));
                if isempty(qaux)
                    break;
                else
                    q6=qaux;
                end

                for q4i=1:length(q4)
                    for q5i=1:length(q5)
                        for q6i=1:length(q6)
                            if round(q5(q5i),3)==0
                                q4(q4i)=0;
                                q6(q6i)=acos(-dot(A03(1:3,1),MTH(1:3,1)));
                            end


%                               ar=deg([q1(i) q2(j) q3(k) q4(q4i) q5(q5i) q6(q6i)])

                           mth=CineD(robot,[q1(i) q2(j) q3(k) q4(q4i) ...
                                q5(q5i) q6(q6i)]);

                            if isequal(round(mth,6), round(MTH,6))
                                q(n,:)=[q1(i) q2(j) q3(k) q4(q4i) ...
                                q5(q5i) q6(q6i)];
                                n=n+1;
                            end
                        end
                    end
                end

            end
        end
    end
end

q=eliminarDobles(q,n-1);
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