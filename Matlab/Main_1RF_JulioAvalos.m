% #-----------------------------------------------------------------------#
% #Primer Examen Recuperatorio
% #Modelo del robot: Racer 3
% #Marca del robot: Comau
% #Datos del Autor.
% #->Nombres: Julio Fabian
% #->Apellidos: Avalos Peralta
% #->C.I: 3877117
% #->Correo: javalos@fiuna.edu.py
% #-----------------------------------------------------------------------#

clear all
close all
clc
%% Se inicializa el robot
r=DefRobot();  %Funcion donde se definen los parametros DH y las caracteristicas del robot
fprintf('\nLos parametros de Denavit Hartenberg para el robot en este caso son:\n')
r  %Los parametros se definieron a mano y en la funcion DefRobot
input('\n¿Desea ontinuar?:')

%% Para el calculo del modelo Cinematico Directo se utiliza la funcion CineD del taller
q0=[0 0 0 0 0 0];
fprintf('\n\nLa matriz de transformacion para la ubicacion de la herramienta es:\n')
MTH=CineD(r,q0)
fprintf('\n\nComparando con el valor proporcionado por la libreria\n')
mth=fkine(r,q0)
input('\n¿Desea ontinuar?:')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Se calcula el paso en radianes para cada articulacion haciendo una regla de 3
%       1 pi/2 rad  -----------  1 s
%        X  rad    ------------  20 ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
paso=(20/1000)*pi/2;    % es lo que se deben mover los eslabones en 20ms

%% Se definen los vectores de posicion para cada eslabon, la posicion que estaran a lo largo del tiempo con un tiempo de muestreo de 20 ms
q1 = r.qlim(1,1):paso:r.qlim(1,2);
qd1 = pi/2*ones(1,length(q1));
qd1(1) = 0;
qd1(end) = 0;
q2 = r.qlim(2,1):paso:r.qlim(2,2);
qd2 = pi/2*ones(1,length(q2));
qd2(1) = 0;
qd2(end) = 0;
largo=max([length(q1) length(q2)]);   % se define la longitud que deberan tener los vectores a lo argo del tiempo de simulacion, los demas se rellenan con 0

%Se define el vector tiempo
t1=0:20/1000:length(q1)*(20/1000);      %se define el tiempo que durara la simulacion
t2=0:20/1000:length(q2)*(20/1000);

%% Se crea una matriz que contendra todos los vectores de posiciones angulares q
Pos1=[q1; zeros(5,length(q1))];   %Matriz que contiene los datos de la primera trayectoria
Pos2=[zeros(1,length(q2)); q2; zeros(4,length(q2))];   %Matriz que contiene los datos de la segunda trayectoria
Qd1=[qd1; zeros(5,length(qd1))];
Qd2=[zeros(1,length(qd2)); qd2; zeros(4,length(qd2))];  %Matrices que contienen las velocidades de los eslabones
                                                        %ambas trayectorias 

%% Primeramente se calculan todas las posiciones de la herramienta a lo largo de la trayectoria
%%Para la trayectoria 1, la funcion tambien devuelve la posicion de cada
%%articulacion y la guarda en el vector rij
for i=1:length(q1)
    [MTH rii]=CineD(r,Pos1(:,i)');
    r11(:,i)=rii(:,1);
    r21(:,i)=rii(:,2);
    r31(:,i)=rii(:,3);
    r41(:,i)=rii(:,4);
    r51(:,i)=rii(:,5);
    r61(:,i)=rii(:,6);
    Herr1(i,:)=MTH(1:3,4);    %En este vector se guardan los vectores p para cada MTH (posicion de la herramienta)
end

%%Para la trayectoria 2
for i=1:length(q2)
    [MTH rii]=CineD(r,Pos2(:,i)');
    r12(:,i)=rii(:,1);
    r22(:,i)=rii(:,2);
    r32(:,i)=rii(:,3);
    r42(:,i)=rii(:,4);
    r52(:,i)=rii(:,5);
    r62(:,i)=rii(:,6);
    Herr2(i,:)=MTH(1:3,4);    %En este vector se guardan los vectores p para cada MTH (posicion de la herramienta)
end

fprintf('/nA continuacion se desplegara el grafico de las posiciones de la herramienta para ambas trayectorias\n\n')

%% Se grafica las posiciones en X, Y y Z de la herramienta para las trayectorias 1 y 2
%Trayectoria 1
figure(1)
subplot(3,2,1)
plot(t1(1:end-1),Herr1(:,1))
title({'TRAYECTORIA 1';'Posicion de la herramienta en X como funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')
subplot(3,2,3)
plot(t1(1:end-1),Herr1(:,2))
title('Posicion de la herramienta en Y como funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')
subplot(3,2,5)
plot(t1(1:end-1),Herr1(:,3))
title('Posicion de la herramienta en Z como funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')

%Trayectoria 2
subplot(3,2,2)
plot(t2(1:end-1),Herr2(:,1))
title({'TRAYECTORIA 2';'Posicion de la herramienta en X como funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')
subplot(3,2,4)
plot(t2(1:end-1),Herr2(:,2))
title('Posicion de la herramienta en Y como funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')
subplot(3,2,6)
plot(t2(1:end-1),Herr2(:,3))
title('Posicion de la herramienta en Z como funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Trayectoria [m]')

input('¿Desea continuar?:')
close figure 1

fprintf('/nA continuacion se desplegara el grafico de las velocidades tanto lineal como angular de la herramienta para ambas trayectorias, ademas la posicion de todas las articulaciones\n\n')

%% Se recurre al calculo del Jacobiano para calcular las velocidades lineales, angulares, y la posicion de cada articulacion
%Para la trayectoria 1
Vx1=zeros(1,length(q1));
Vy1=zeros(1,length(q1));
Vz1=zeros(1,length(q1));
Wx1=zeros(1,length(q1));
Wy1=zeros(1,length(q1));
Wz1=zeros(1,length(q1));
for i=1:length(q1)-1
    Ja=jacob0(r,Pos1(:,i)');
    Vx1(i)=Ja(1,:)*Qd1(:,i);
    Vy1(i)=Ja(2,:)*Qd1(:,i);
    Vz1(i)=Ja(3,:)*Qd1(:,i);
    Wx1(i)=Ja(4,:)*Qd1(:,i);
    Wy1(i)=Ja(5,:)*Qd1(:,i);
    Wz1(i)=Ja(6,:)*Qd1(:,i);
end                       

figure(2)
subplot(3,2,1)
plot(t1(1:end-1),Vx1)
title({'TRAYECTORIA 1';'Velocidad lineal en X de la herramienta en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

subplot(3,2,3)
plot(t1(1:end-1),Vy1)
title('Velocidad lineal en Y de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

subplot(3,2,5)
plot(t1(1:end-1),Vz1)
title('Velocidad lineal en Z de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

figure(3)
subplot(3,2,1)
plot(t1(1:end-1),Wx1)
title({'TRAYECTORIA 1';'Velocidad angular en X de la herramienta en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

subplot(3,2,3)
plot(t1(1:end-1),Wy1)
title('Velocidad angular en Y de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

subplot(3,2,5)
plot(t1(1:end-1),Wz1)
title('Velocidad angular en Z de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

figure(4)
subplot(3,2,1)
hold on
plot(t1(1:end-1),r11(1,:))
plot(t1(1:end-1),r21(1,:))
plot(t1(1:end-1),r31(1,:))
plot(t1(1:end-1),r41(1,:))
plot(t1(1:end-1),r51(1,:))
plot(t1(1:end-1),r61(1,:))
hold off
title({'TRAYECTORIA 1';'Posicion en X de las articulaciones en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
subplot(3,2,3)
hold on
plot(t1(1:end-1),r11(2,:))
plot(t1(1:end-1),r21(2,:))
plot(t1(1:end-1),r31(2,:))
plot(t1(1:end-1),r41(2,:))
plot(t1(1:end-1),r51(2,:))
plot(t1(1:end-1),r61(2,:))
hold off
title('Posicion en Y de las articulaciones en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
subplot(3,2,5)
hold on
plot(t1(1:end-1),r11(3,:))
plot(t1(1:end-1),r21(3,:))
plot(t1(1:end-1),r31(3,:))
plot(t1(1:end-1),r41(3,:))
plot(t1(1:end-1),r51(3,:))
plot(t1(1:end-1),r61(3,:))
hold off
title('Posicion en Z de las articulaciones en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')

%Para la trayectoria 2
Vx2=zeros(1,length(q2));
Vy2=zeros(1,length(q2));
Vz2=zeros(1,length(q2));
Wx2=zeros(1,length(q2));
Wy2=zeros(1,length(q2));
Wz2=zeros(1,length(q2));
for i=1:length(q2)-1
    Ja=jacob0(r,Pos2(:,i)');
    Vx2(i)=Ja(1,:)*Qd2(:,i);
    Vy2(i)=Ja(2,:)*Qd2(:,i);
    Vz2(i)=Ja(3,:)*Qd2(:,i);
    Wx2(i)=Ja(4,:)*Qd2(:,i);
    Wy2(i)=Ja(5,:)*Qd2(:,i);
    Wz2(i)=Ja(6,:)*Qd2(:,i);   
end                        

figure(2)
subplot(3,2,2)
plot(t2(1:end-1),Vx2)
title({'TRAYECTORIA 2';'Velocidad lineal en X de la herramienta en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

subplot(3,2,4)
plot(t2(1:end-1),Vy2)
title('Velocidad lineal en Y de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

subplot(3,2,6)
plot(t2(1:end-1),Vz2)
title('Velocidad lineal en Z de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [m/s]')

figure(3)
subplot(3,2,2)
plot(t2(1:end-1),Wx2)
title({'TRAYECTORIA 2';'Velocidad angular en X de la herramienta en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

subplot(3,2,4)
plot(t2(1:end-1),Wy2)
title('Velocidad angular en Y de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

subplot(3,2,6)
plot(t2(1:end-1),Wz2)
title('Velocidad angular en Z de la herramienta en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')

figure(4)
subplot(3,2,2)
hold on
plot(t2(1:end-1),r12(1,:))
plot(t2(1:end-1),r22(1,:))
plot(t2(1:end-1),r32(1,:))
plot(t2(1:end-1),r42(1,:))
plot(t2(1:end-1),r52(1,:))
plot(t2(1:end-1),r62(1,:))
hold off
title({'TRAYECTORIA 2';'Posicion en X de las articulaciones en funcion del tiempo'})
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
subplot(3,2,4)
hold on
plot(t2(1:end-1),r12(2,:))
plot(t2(1:end-1),r22(2,:))
plot(t2(1:end-1),r32(2,:))
plot(t2(1:end-1),r42(2,:))
plot(t2(1:end-1),r52(2,:))
plot(t2(1:end-1),r62(2,:))
hold off
title('Posicion en Y de las articulaciones en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
subplot(3,2,6)
hold on
plot(t2(1:end-1),r12(3,:))
plot(t2(1:end-1),r22(3,:))
plot(t2(1:end-1),r32(3,:))
plot(t2(1:end-1),r42(3,:))
plot(t2(1:end-1),r52(3,:))
plot(t2(1:end-1),r62(3,:))
hold off
title('Posicion en Z de las articulaciones en funcion del tiempo')
xlabel('Tiempo [s]') 
ylabel('Posicion [m]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')

input('¿Desea continuar?:')
close figure 2
close figure 3
close figure 4


fprintf('/nA continuacion se desplegara el grafico de las velocidades angulares de cada articulacion para ambas trayectorias\n\n')
%% Velocidad articular de cada articulacion
%En este caso las velocidades son contantes y definidas por las
%trayectorias 1 y 2
figure(5)
subplot(2,1,1)
plot(t1(1:end-1),Qd1(1,:))
hold on
plot(t1(1:end-1),Qd1(2,:))
hold on
plot(t1(1:end-1),Qd1(3,:))
hold on
plot(t1(1:end-1),Qd1(4,:))
hold on
plot(t1(1:end-1),Qd1(5,:))
hold on
plot(t1(1:end-1),Qd1(6,:))
title({'TRAYECTORIA 1';'Velocidades articulares (angulares) de las articulaciones'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
hold off
subplot(2,1,2)
plot(t2(1:end-1),Qd2(1,:))
hold on
plot(t2(1:end-1),Qd2(2,:))
hold on
plot(t2(1:end-1),Qd2(3,:))
hold on
plot(t2(1:end-1),Qd2(4,:))
hold on
plot(t2(1:end-1),Qd2(5,:))
hold on
plot(t2(1:end-1),Qd2(6,:))
title({'TRAYECTORIA 2';'Velocidades articulares (angulares) de las articulaciones'})
xlabel('Tiempo [s]') 
ylabel('Velocidad [rad/s]')
legend('articulacion 1','articulacion 2','articulacion 3','articulacion 4','articulacion 5','articulacion 6')
hold off

input('¿Desea continuar?:')
close figure 5

fprintf('/nA continuacion se desplegara el grafico de los torques en cada articulacion para ambas trayectorias, y para una configuracion con carga y sin carga\n\n')

%% Para el calculo de los Pares se realiza a partir del calculo del algoritmo de Newton Euler, se deben considerar
%las trayectorias 1 y 2 y la carga como fuerza externa
%Trayectoria 1 y 2 sin carga
for i=1:length(q1)
    tau11(i,:) = r.rne(Pos1(:,i)',Qd1(:,i)',zeros(6,1)',[0,0,-9.81]);
end
for i=1:length(q2)
    tau12(i,:) = r.rne(Pos2(:,i)',Qd2(:,i)',zeros(6,1)',[0,0,-9.81]);
end
figure(6)
subplot(6,2,1)
plot(t1(1:end-1),tau11(:,1))
title({'TRAYECTORIA 1 (sin fuerza externa)','Tau para la articulacion 1'})
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,3)
plot(t1(1:end-1),tau11(:,2))
title('Tau para la articulacion 2')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,5)
plot(t1(1:end-1),tau11(:,3))
title('Tau para la articulacion 3')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,7)
plot(t1(1:end-1),tau11(:,4))
title('Tau para la articulacion 4')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,9)
plot(t1(1:end-1),tau11(:,5))
title('Tau para la articulacion 5')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,11)
plot(t1(1:end-1),tau11(:,6))
title('Tau para la articulacion 6')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')

subplot(6,2,2)
plot(t2(1:end-1),tau12(:,1))
title({'TRAYECTORIA 2 (sin fuerza externa)','Tau para la articulacion 1'})
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,4)
plot(t2(1:end-1),tau12(:,2))
title('Tau para la articulacion 2')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,6)
plot(t2(1:end-1),tau12(:,3))
title('Tau para la articulacion 3')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,8)
plot(t2(1:end-1),tau12(:,4))
title('Tau para la articulacion 4')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,10)
plot(t2(1:end-1),tau12(:,5))
title('Tau para la articulacion 5')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,12)
plot(t2(1:end-1),tau12(:,6))
title('Tau para la articulacion 6')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')

%Trayectoria 2
W=[0 0 -0.8*9.81 0 0 0]';
for i=1:length(q1)
    tau21(i,:) = r.rne(Pos1(:,i)',Qd1(:,i)',zeros(6,1)',[0,0,-9.81],W);
end
for i=1:length(q2)
    tau22(i,:) = r.rne(Pos2(:,i)',Qd2(:,i)',zeros(6,1)',[0,0,-9.81],W);
end

figure(7)
subplot(6,2,1)
plot(t1(1:end-1),tau21(:,1))
title({'TRAYECTORIA 1 (con fuerza externa)','Tau para la articulacion 1'})
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,3)
plot(t1(1:end-1),tau21(:,2))
title('Tau para la articulacion 2')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,5)
plot(t1(1:end-1),tau21(:,3))
title('Tau para la articulacion 3')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,7)
plot(t1(1:end-1),tau21(:,4))
title('Tau para la articulacion 4')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,9)
plot(t1(1:end-1),tau21(:,5))
title('Tau para la articulacion 5')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,11)
plot(t1(1:end-1),tau21(:,6))
title('Tau para la articulacion 6')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')

subplot(6,2,2)
plot(t2(1:end-1),tau22(:,1))
title({'TRAYECTORIA 2 (con fuerza externa)','Tau para la articulacion 1'})
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,4)
plot(t2(1:end-1),tau22(:,2))
title('Tau para la articulacion 2')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,6)
plot(t2(1:end-1),tau22(:,3))
title('Tau para la articulacion 3')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,8)
plot(t2(1:end-1),tau22(:,4))
title('Tau para la articulacion 4')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,10)
plot(t2(1:end-1),tau22(:,5))
title('Tau para la articulacion 5')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')
subplot(6,2,12)
plot(t2(1:end-1),tau22(:,6))
title('Tau para la articulacion 6')
xlabel('Tiempo [s]') 
ylabel('Torque [Nm]')

input('¿Finalizar?:')
close figure 6
close figure 7