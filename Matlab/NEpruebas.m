%script de prueba de la funcion NEDiIn, generamos unas variables de prueba
%para q, qd, y qdd y compilamos paso a paso con el depurador de matlab
syms theta1 theta2 theta1d theta2d theta1dd theta2dd theta3 theta4 theta3d theta4d theta3dd theta4dd g
%% Definimos un qprueba
qprueba=[theta1 theta2 theta3 theta4];
qdprueba=[theta1d theta2d theta3d theta4d];
qddprueba=[theta1dd theta2dd theta3dd theta4dd];

%% Llamamos a la funcion NEDiIn


[tau,R]=NEDiIn(qprueba, qdprueba, qddprueba,[0 0 -g],0.05*eye(3)); %el ultimo suele ser zeros(3,2)

m1=10 ;
m2=5 ;
m3= 5;
m4= 3;

L1=0.4 ;
L2=0.2;
%d1=6;
%d2=6;
a1=0.1;
theta1= 0 ;
theta2= 0.5 ;
theta3= 0.4 ;
theta4= 0 ;
theta1d= 0 ;
theta2d= 0 ;
theta3d= 0 ;
theta4d= 0 ;
theta1dd= theta1d ;
theta2dd= theta2d ;
theta3dd= theta3d ;
theta4dd= theta4d ;
g=9.8;