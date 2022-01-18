close all
clear all
clc
% #-----------------------------------------------------------------------#
% #Definicion del objeto Robot para Robotics Toolbox Version 10.4
% #Modelo del robot: Racer 3
% #Marca del robot: Comau
% #Datos del Autor.
% #->Nombres: Avalos Peralta
% #->Apellidos: Julio Fabian
% #->C.I: 3877117
% #->Correo: javalos@fiuna.edu.py
% #-----------------------------------------------------------------------#

%% Medidas de los eslabones
a1=365;
a2=50;
a3=270;
a4=400;
a5=305.94;
%a6=80;

 %% Parametros DH
d=[a1  0    0   0  a5];
a=[a2  -a3   a4  0   0];
alpha=[pi/2  pi  pi  -pi/2  0];
offset=[pi/2  -pi/2  -pi/2   -pi/2   0];

%% Creacion de los eslabones
L1=Link('d',d(1),'a',a(1),'alpha',alpha(1),'offset',offset(1));
L2=Link('d',d(2),'a',a(2),'alpha',alpha(2),'offset',offset(2));
L3=Link('d',d(3),'a',a(3),'alpha',alpha(3),'offset',offset(3));
L4=Link('d',d(4),'a',a(4),'alpha',alpha(4),'offset',offset(4));
L5=Link('d',d(5),'a',a(5),'alpha',alpha(5),'offset',offset(5));
%L6=Link('d',d(6),'a',a(6),'alpha',alpha(6),'offset',offset(6));

%% Limites de las articulaciones
L1.qlim=[-90 90]*pi/180;
L2.qlim=[-90 90]*pi/180;
L3.qlim=[-90 90]*pi/180;
%L4.qlim=[-200 200]*pi/180;
L4.qlim=[-90 90]*pi/180;
L5.qlim=[-90 90]*pi/180;
%L6.qlim=[-360 360]*pi/180;  % Reduce en una vuelta, ambos sentidos
%L6.qlim=[-176 176]*pi/180;

%% Se define el objeto Robot usando el constructor SerialLink
L=[L1 L2 L3 L4 L5];
r = SerialLink(L);
r.name='Comau_{Racer3}';
%Vector de pruebas
q=zeros(1,5);

%% Transformacion necesaria para la base
%r.base=[rotx(pi) [0 0 0]';0 0 0 1];
%r.tool=[rotz(pi) [1 0 0]';0 0 0 1]
plot(r,q)
clear L L1 L2 L3 L4 L5 L6 a d alpha offset a1 a2 a3 a4 a5 a6
%para verificar MTH = cineD(r,q) -> fkine(r,q)
%cinematica inversa q = cineI(r,MTH) -> ikine(r,MTH)