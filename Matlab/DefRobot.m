% #-----------------------------------------------------------------------#
% #Definicion del objeto Robot para Robotics Toolbox Version 10.4
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
%-----------Medidas eslabones en metros-------------------------------------------#
a1=10;
a2=2;
a3=12;
a4=12;
a5=12;

%----------Parametros DH--------------------------------------------------#
d=[a1  0    0   0  a5];
a=[a2  -a3   a4  0   0];
alpha=[pi/2  pi  pi  -pi/2  0];
offset=[pi/2  -pi/2  pi   -pi/2   0];

%---------Creacion de eslabones-------------------------------------------#
L1=Link('d',d(1),'a',a(1),'alpha',alpha(1),'offset',offset(1));
L2=Link('d',d(2),'a',a(2),'alpha',alpha(2),'offset',offset(2));
L3=Link('d',d(3),'a',a(3),'alpha',alpha(3),'offset',offset(3));
L4=Link('d',d(4),'a',a(4),'alpha',alpha(4),'offset',offset(4));
L5=Link('d',d(5),'a',a(5),'alpha',alpha(5),'offset',offset(5));

%% Limites de las articulaciones
L1.qlim=[-90 90]*pi/180;
L2.qlim=[-90 90]*pi/180;
L3.qlim=[-90 90]*pi/180;
L4.qlim=[-90 90]*pi/180;
L5.qlim=[-90 90]*pi/180;


%-------------Definición de masas-----------------------------------------#
% Para asignar los pesos se utiliza el criterio: Longitud Eslabon [m] * 1 [kg/m] 

%w = 30;    %Peso del Robot
L1.m = sqrt(a1^2+a2^2);
L2.m = a3;
L3.m = a4;
L4.m = a5;
L5.m = 0;  %donde las a son las medidas en metros de los eslabones
%----------Definimos los centros de gravedad------------------------------#
% Los centros de gravedad de los eslabones se definen con respecto a
%  al sistema {Si}, se consideran masas puntuales ubicadas a la mitad de
%  cada eslabon

 L1.r = [ -a2/2    a1/2  0];
 L2.r = [ -a3/2  0    0];
 L3.r = [ -a4/2     0    0];
 L4.r = [ 0    -a5/2  0];
 L5.r = [ 0    0	   -a5/2];
%-------Inercias de los eslabones-----------------------------------------#
%Por simplicidad vamos a considerar que todos los eslabones tienen masas
%puntuales por lo que sus inercias son nulas.
L1.I=zeros(3,3);
L2.I=zeros(3,3);
L3.I=zeros(3,3);
L4.I=zeros(3,3);
L5.I=zeros(3,3);
%---Definimos el objeto Robot. Usaremos el constructor SerialLink---------#
L=[L1 L2 L3 L4 L5];
r = SerialLink(L);
r.name='Comau_{Racer3}';

clear L L1 L2 L3 L4 L5 L6 a d alpha offset a1 a2 a3 a4 a5 a6
%para verificar cineD(r,q) -> fkine(r,q)
%cinematica inversa ikine
