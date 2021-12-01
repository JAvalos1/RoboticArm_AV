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

%%Medidas eslabones
syms a1 a2 a3 a4 a5 a6 pix q1 q2 q3 q4 q5 q6 LT


%%Parametros DH
d=[a1  0    0   -a5  0  -a6];
a=[ a2  a3   a4  0   0  0];
alpha=[-pix/2 -pix   -pix/2  -pix/2 pix/2 pix];
offset=[pix/2  -pix/2  pix/4     0     0    0];
qi=[q1 q2 q3 q4 q5 q6];
A=[rotx(-pi/2) [0 0 1.3*LT]';0 0 0 1];
for i=4:6
    A = A*DH(qi(i)+offset(i),d(i),a(i),alpha(i))
end

A=simplify(A)

 
 