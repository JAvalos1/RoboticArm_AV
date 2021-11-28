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

function MTH=CineD(robot,q)
qlim=robot.qlim;
    
    if q(1)<qlim(1,1) || q(1)>qlim(1,2)
         error('El valor de la articulacion 1 es invalido');
    elseif q(2)<qlim(2,1) || q(2)>qlim(2,2)
         error('El valor de la articulacion 2 es invalido');
    elseif q(3)<qlim(3,1) || q(3)>qlim(3,2)
         error('El valor de la articulacion 3 es invalido ');
    elseif q(4)<qlim(4,1) || q(4)>qlim(4,2)
         error('El valor de la articulacion 4 es invalido ');
    elseif q(5)<qlim(5,1) || q(5)>qlim(5,2)
         error('El valor de la articulacion 5 es invalido ');
    elseif q(6)<qlim(6,1) || q(6)>qlim(6,2)
         error('El valor de la articulacion 6 es invalido ');
    end
    
alpha = robot.alpha;
a = robot.a;
theta = q + robot.offset;
d = robot.d;
LT=a(1)+a(3)+a(4)+a(5)+a(6);
MTH=[rotx(-pi/2) [0 0 1.3*LT]';0 0 0 1];
for i=1:6
        MTH=MTH*DH(theta(i),d(i),a(i),alpha(i));
end

end