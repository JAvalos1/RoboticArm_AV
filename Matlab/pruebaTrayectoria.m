%Codigo prueba de la funcion de TareaMontaje
%% Definir el robot
close all
r=DefRobot

%% Definir la posicion en el espacio cartesiano
%Los puntos deben estar en un plano paralelo al plno Y0Z0
%Los puntos inicial y final tienen los valores noa paralelos
%al los ejes del sistema S0 con el vector n perpendicular al
%plano de trabajo.

xvec=-0.5:0.1/10:0.5;
yvec=0.2*sin(0.6*xvec)+abs(0.2*xvec)+0.5;
zvec=0.4*xvec+0.6;

MTHA=[-1 0 0 xvec(1);
       0 0 1 yvec(1);
       0 1 0 zvec(1);
       0 0 0 1];
   
MTHB=[-1 0 0 xvec(end);
       0 0 1 yvec(end);
       0 1 0 zvec(end);
       0 0 0 1];

%% Generar noap_herramienta
%usaremos dos tipos de curvas
%Curva1: Recta de A a B
%Curva2: Circulo de centro en AB/2
%curva=1;
tipo=1;
Res=0.1;
mi=30;
%[noap,n]=GenerarCurva(curva,MTHA, MTHB,Res/5);
n=length(xvec);
noap=zeros(4,4,n);
for i=1:n
    noap(:,:,i)=[0 1 0 xvec(i);
                 0 0 1 yvec(i);
                 1 0 0 zvec(i);
                 0 0 0 1];
end

disp('Introduzca el tipo de interpolador que desea probar')
disp('0-->Interpolador Lineal')
disp('1-->Interpolador a tramos')
disp('2-->Interpolador Cubica')
interpolador=input('\nEleccion:');
% #Interpolador Lineal
if interpolador==0

[q, qd, qdd, tau] = Trayectoria(r,mi, tipo,...
    noap, Res, interpolador);
% #Interpolador cubica
elseif interpolador==2
[q, qd, qdd, tau] = Trayectoria(r,mi, tipo,...
    noap, Res, interpolador);
% #interpolador a tramos
elseif interpolador==1
[q, qd, qdd, tau] = Trayectoria(r,mi, tipo,...
    noap, Res, interpolador);
end

[N dm] = size(q);
%% Presentación de resultados
close all
figure(1)
axis([-01 1 -1 1 -0 1])
title('Resultados')

plot3(MTHA(1,4),MTHA(2,4),MTHA(3,4),'x');
hold on
plot3(MTHB(1,4),MTHB(2,4),MTHB(3,4),'x');
hold on
for i=1:n
    plot3(noap(1,4,i),noap(2,4,i),noap(3,4,i),'or');
    hold on
end
for i=1:N
    %dibujar el robot
%     plot(r,q(i,:))
     %pause(0.01)
    %obtener coordenadas XYZ
    Pact=CineD(r,q(i,:));
    plot3(Pact(1,4),Pact(2,4),Pact(3,4),'.g')
end
%% Como el valor de la compente en x del vector p no varia vemos cual 
%es el error para el tipo de interpolacion
x1=zeros(1,N);
for i=1:N
    aux=CineD(r,q(i,:));
    x1(i)=aux(1,4);
end
x=MTHA(1,4);
figure(2)
plot((x-x1),'b')
