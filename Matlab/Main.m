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

%% Para el calculo del modelo Cinematico Directo se utiliza la funcion CineD del taller
q0=[0 0 0 0 0 0];
fprintf('\n\nLa matriz de transformacion para la ubicacion de la herramienta es:\n')
MTH=CineD(r,q0)
fprintf('\n\nComparando con el valor proporcionado por la libreria\n')
fkine(r,q0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Se calcula el paso en radianes para cada articulacion haciendo una regla de 3
%       1 pi rad  -----------  1 s
%        X  rad   ------------  20 ms
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
paso=(20/1000)*pi/2;    % es lo que se deben mover los eslabones en 20ms
t=0:20/1000:61*(20/1000);      %se define el tiempo que durara la simulacion

%% Se definen los vectores de posicion para cada eslabon, la posicion que estaran a lo largo del tiempo con un tiempo de muestreo de 20 ms
q1 = q(1,1):paso:q(1,2);
qd1 = pi*ones(1,length(q1));
q2 = q(2,1):paso:q(2,2);
qd2 = pi*ones(1,length(q2));
q3 = q(3,1):paso:q(3,2);
qd3 = pi*ones(1,length(q3));
q4 = q(4,1):paso:q(4,2);
qd4 = pi*ones(1,length(q4));
q5 = q(5,1):paso:q(5,2);
qd5 = pi*ones(1,length(q5));
q6 = q(6,1):paso:q(6,2);
qd6 = pi*ones(1,length(q6));
largo=max([length(q1) length(q2) length(q3) length(q4) length(q5) length(q6)]);   % se define la longitud que deberan tener los vectores a lo argo del tiempo de simulacion, los demas se rellenan con 0
%% Se crea una matriz que contendra todos los vectores de posiciones angulares q
q1 = [q1 q(1,2)*ones(1,largo-length(q1))];
qd1 = [qd1 zeros(1,largo-length(qd1))];
q2 = [q2 q(2,2)*ones(1,largo-length(q2))];
qd2 = [qd2 zeros(1,largo-length(qd2))];
q3 = [q3 q(3,2)*ones(1,largo-length(q3))];
qd3 = [qd3 zeros(1,largo-length(qd3))];
q4 = [q4 q(4,2)*ones(1,largo-length(q4))];
qd4 = [qd4 zeros(1,largo-length(qd4))];
q5 = [q5 q(5,2)*ones(1,largo-length(q5))];
qd5 = [qd5 zeros(1,largo-length(qd5))];
q6 = [q6 q(6,2)*ones(1,largo-length(q6))];
qd6 = [qd6 zeros(1,largo-length(qd6))];
Pos=[q1; q2; q3; q4; q5; q6];
Qd=[qd1; qd2; qd3; qd4; qd5; qd6];

%% Primeramente se calculan todas las posiciones de la herramienta a lo largo de la trayectoria
for i=1:largo
    MTH=CineD(r,Pos(:,i)');
    Herr(i,:)=MTH(1:3,4);    %En este vector se guardan los vectores p para cada MTH (posicion de la herramienta)
end
%% Se grafica las posiciones el X, Y y Z de la herramienta
figure(1)
subplot(3,1,1)
plot(Herr(:,1))
title('Posicion de X en funcion del tiempo')
subplot(3,1,2)
plot(Herr(:,2))
title('Posicion de Y en funcion del tiempo')
subplot(3,1,3)
plot(Herr(:,3))
title('Posicion de Z en funcion del tiempo')

%% Se recurre al calculo del Jacobiano para calcular las velocidades lineales, angulares, y la posicion de cada articulacion
Vx=zeros(1,largo);
Vy=zeros(1,largo);
Vz=zeros(1,largo);
Wx=zeros(1,largo);
Wy=zeros(1,largo);
Wz=zeros(1,largo);
for i=1:largo-1
    Ja=jacob0(r,Pos(:,i)');
    Vx(i)=Ja(1,:)*Qd(:,i);
    Vy(i)=Ja(2,:)*Qd(:,i);
    Vz(i)=Ja(3,:)*Qd(:,i);
    Wx(i)=Ja(4,:)*Qd(:,i);
    Wy(i)=Ja(5,:)*Qd(:,i);
    Wz(i)=Ja(6,:)*Qd(:,i);
    %A01=A(:,:,1);
    %r1(i,:)=A01(1:3,4);
    %A02=A01*A(:,:,2);
    %r2(i,:)=A02(1:3,4);
    %A03=A02*A(:,:,3);
    %r3(i,:)=A03(1:3,4);
    %A04=A03*A(:,:,4);
    %r4(i,:)=A04(1:3,4);
    %A05=A04*A(:,:,5);
    %r5(i,:)=A05(1:3,4);
    %A06=A05*A(:,:,6);
    %r6(i,:)=A06(1:3,4);   % Guarde de cada matriz jacobiana las primeras 3 filas (Vlineal) y las ultimas 3 filas (Vangular) para cada articulacion
end                            % En los vectores r 1 al 6 guarde los vectores p de cada matriz de transformacion 

figure(2)
subplot(3,1,1)
plot(Vx)
title('Velocidades lineales en X de las articulaciones en funcion del tiempo')

subplot(3,1,2)
plot(Vy)
title('Velocidades lineales en Y de las articulaciones en funcion del tiempo')

subplot(3,1,3)
plot(Vz)
title('Velocidades lineales en Z de las articulaciones en funcion del tiempo')

figure(3)
subplot(3,1,1)
plot(Wx)
title('Velocidades angulares en X de las articulaciones en funcion del tiempo')

subplot(3,1,2)
plot(Wy)
title('Velocidades angulares en Y de las articulaciones en funcion del tiempo')

subplot(3,1,3)
plot(Wz)
title('Velocidades angulares en Z de las articulaciones en funcion del tiempo')

% figure(4)
% subplot(3,1,1)
% hold on
% plot(r1(:,1))
% plot(r2(:,1))
% plot(r3(:,1))
% plot(r4(:,1))
% plot(r5(:,1))
% plot(r6(:,1))
% hold off
% title('Posicion en X de las articulaciones en funcion del tiempo')
% subplot(3,1,2)
% hold on
% plot(r1(:,2))
% plot(r2(:,2))
% plot(r3(:,2))
% plot(r4(:,2))
% plot(r5(:,2))
% plot(r6(:,2))
% hold off
% title('Posicion en Y de las articulaciones en funcion del tiempo')
% subplot(3,1,3)
% hold on
% plot(r1(:,3))
% plot(r2(:,3))
% plot(r3(:,3))
% plot(r4(:,3))
% plot(r5(:,3))
% plot(r6(:,3))
% hold off
% title('Posicion en Z de las articulaciones en funcion del tiempo')

%% Para el calculo de los Pares se realiza a partir del calculo del algoritmo de Newton Euler
for i=1:largo
    tau(i,:) = NEDiIn(r, Pos(:,i)', Qd(:,i)', [0 0 0 0 0 0], [0 0 -9.8], zeros(3,2));
end
figure(5)
subplot(3,2,1)
plot(tau(:,1),t)
hold on
[a,b]=max(abs(tau(:,1)));
plot(t(b),tau(b,1),'x')
title('Tau para la articulacion 1')
subplot(3,2,2)
plot(tau(:,2))
title('Tau para la articulacion 2')
subplot(3,2,3)
plot(tau(:,3))
title('Tau para la articulacion 3')
subplot(3,2,4)
plot(tau(:,4))
title('Tau para la articulacion 4')
subplot(3,2,5)
plot(tau(:,5))
title('Tau para la articulacion 5')
subplot(3,2,6)
plot(tau(:,6))
title('Tau para la articulacion 6')

%% PARTE B
% Calculo del maximo par que se genera en cada articulacion
fprintf('El par maximo para cada articulacion es, en orden 1 al 6: ')
max(abs(tau(:,1)))
max(tau(:,2))
max(tau(:,3))
max(tau(:,4))
max(tau(:,5))
max(tau(:,6))