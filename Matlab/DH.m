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

function dh=DH(teta, d, a, alfa)
dh=[cos(teta)  -cos(alfa)*sin(teta)   sin(alfa)*sin(teta)   a*cos(teta);
    sin(teta)   cos(alfa)*cos(teta)  -sin(alfa)*cos(teta)   a*sin(teta);
           0              sin(alfa)             cos(alfa)             d;
           0                     0                     0              1];
end