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

%-----------Medidas eslabones---------------------------------------------#

a1=365/1000;
a2=50/1000;
a3=270/1000;
a4=50/1000;
a5=305.94/1000;
a6=80/1000;

%----------Parametros DH--------------------------------------------------#
d=[a1  0    0   -a5  0  -a6];
a=[ a2  a3   a4  0   0  0];
alpha=[-pi/2 pi   -pi/2  -pi/2 pi/2 pi];
offset=[0    -pi/2  0     0     0    pi];

%---------Creacion de eslabones-------------------------------------------#
L1=Link('d',d(1),'a',a(1),'alpha',alpha(1),'offset',offset(1));
L2=Link('d',d(2),'a',a(2),'alpha',alpha(2),'offset',offset(2));
L3=Link('d',d(3),'a',a(3),'alpha',alpha(3),'offset',offset(3));
L4=Link('d',d(4),'a',a(4),'alpha',alpha(4),'offset',offset(4));
L5=Link('d',d(5),'a',a(5),'alpha',alpha(5),'offset',offset(5));
L6=Link('d',d(6),'a',a(6),'alpha',alpha(6),'offset',offset(6));

%-------------Definicion de limites de articulaciones---------------------#
% L1.qlim=[-170 170]*pi/180;
% L2.qlim=[-100 145]*pi/180;
% L3.qlim=[-70 205]*pi/180;
% L4.qlim=[-190 190]*pi/180;
% L5.qlim=[-125 125]*pi/180;
% L6.qlim=[-360 360]*pi/180;
L1.qlim=[-170 170]*pi/180;
L2.qlim=[-95 135]*pi/180;
L3.qlim=[-155 90]*pi/180;
%L4.qlim=[-200 200]*pi/180;
L4.qlim=[-176 176]*pi/180;
L5.qlim=[-125 125]*pi/180;
%L6.qlim=[-360 360]*pi/180;  % Reduce en una vuelta, ambos sentidos
L6.qlim=[-176 176]*pi/180;

%-------------Definición de masas-----------------------------------------#
% #Para definir el valor de las masas de nuestro robot vamos a considerar
%  como sigue: El primer eslabon tendra el 70% de la masa total, el segundo
%  tendra el 70% de la masa restante, y asi sucesivamente.

w = 30;
L1.m = w*0.7;
L2.m = w*0.3*0.7;
L3.m = w*0.3^2*0.7;
L4.m = w*0.3^3*0.7;
L5.m = w*0.3^4*0.7;
L6.m = w*0.3^5*0.7;
%----------Definimos los centros de gravedad------------------------------#
% Los centros de gravedad de los eslabones se definen con respecto a
%  al sistema {Si}

 L1.r = [ -a2/2    a1/2  0];
 L2.r = [ -a3/2  0    0];
 L3.r = [ -a4/2     0    0];
 L4.r = [ 0    -a5/2  0];
 L5.r = [ 0    0	   0];
 L6.r = [ 0    0	-a6/2];
%-------Inercias de los eslabones-----------------------------------------#
%Por simplicidad vamos a considerar que todos los eslabones tienen masas
%puntuales por lo que sus inercias son nulas.
L1.I=zeros(3,3);
L2.I=zeros(3,3);
L3.I=zeros(3,3);
L4.I=zeros(3,3);
L5.I=zeros(3,3);
L6.I=zeros(3,3);
%---Definimos el objeto Robot. Usaremos el constructor SerialLink---------#
L=[L1 L2 L3 L4 L5 L6];
r = SerialLink(L);
r.name='Comau_{Racer3}';
%Vector de pruebas
q=zeros(1,6);

%-----Transformacion para la base---------------------------#
%r.base=[rotx(pi) [0 0 0]';0 0 0 1];
%r.tool=[rotz(pi) [1 0 0]';0 0 0 1]
plot(r,q)
clear L L1 L2 L3 L4 L5 L6 a d alpha offset a1 a2 a3 a4 a5 a6
%para verificar cineD(r,q) -> fkine(r,q)
%cinematica inversa ikine