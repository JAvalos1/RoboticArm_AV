% #-----------------------------------------------------------------------#
% #Definicion del objeto Robot para Robotics Toolbox Version 10.4
% #Modelo del robot: LR Mate 200iD
% #Marca del robot: Fanuc
% #Datos del Autor.
% #->Nombres:
% #->Apellidos:
% #->C.I:
% #->Correo:
% #Calculo simpbolico de las matrices
% #-----------------------------------------------------------------------#

%%Medidas eslabones 
syms a1 a2 a3 a4 a5 pix q1 q2 q3 q4 q5 q_i alpha_i d_i a_i

%%Parametros DH
d=[a1  0    0   0  a5];
a=[a2  -a3   a4  0   0];
alpha=[pix/2  pix  pix  -pix/2  0];
offset=[pix/2  -pix/2  pix   -pix/2   0];
qi=[q1 q2 q3 q4 q5];

A=eye(4,4);
u=eye(4,4);
for i=1:5
    A=A*denavit(qi(i)+offset(i),d(i),a(i),alpha(i))
    %u=u*denavit(qi(i),d(i),a(i),alpha(i));
end

%u=denavit(q_i,d_i,a_i,alpha_i)






 