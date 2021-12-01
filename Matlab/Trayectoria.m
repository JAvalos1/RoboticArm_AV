% #-----------------------------------------------------------------------#
% #[q, qd, qdd, tau, e] = Trayectoria(robot,mi, tipo, noap_herramienta, Res, interpolador)
% #Robot: Objeto robot
% #mi: masa externa que transporta el robot
% #tipo: tipo de movimiento deseado, 1 para coordinado, 0 para simultaneo
% #noap_herramienta: Matriz nx4x4 que contine los puntos por lo que debe
% pasar la herramienta
% #Res: Resolucion de referencia
% #Interpolador: tipo de interpolacion, 0 lineal, 1 a tramos, 2 cubica
% #
% #q:valores de las variables articulares que son necesarios para realizar
% la curva deescrita por noap_herramienta
% #qd: velocidad de las variables articulares
% #qdd: aceleracion de las variables articulares
% #tau: torque de las articulaciones
% #Datos del Autor.
% #->Nombres:
% #->Apellidos:
% #->C.I:
% #->Correo:
% #-----------------------------------------------------------------------#

function [q, qd, qdd, tau] = Trayectoria(robot,mi, tipo, noap_herramienta, Res, interpolador)
n=size(noap_herramienta);
n=n(3);
q=zeros(n,8,6);                                             %<---Se crea una matriz que va a contener las soluciones de la cinematica inversa
for i=1:n
    qres=CineI(robot,noap_herramienta(:,:,i));              %<---Se cargan las soluciones de la cinematica inversa
    tam=size(qres);
    q(i,:,:)=[qres;zeros(8-tam(1),6)];                      %<---En el caso de no tener las 8 soluciones se rellenan con ceros
end

disp('Estas son las soluciones generadas, seleccione una(indice de la figura)')

for i=1:8                                                   %<---El algoritmo hace una ordenacion de las soluciones, por lo que podemos hacer una grafica para saber que cual es la mejor
figure(i)
    for j=1:6
        plot(q(:,i,j)*180/pi)
        hold on
%         pause(1)
    end
%     pause(2)
end
sol=input('\n Solucion:');                                 %<---Se elige una de las graficas de acuerdo al indice de la figura
q=q(:,sol,:);
%% reordenar q
aux=zeros(n,6);                                            %<---La matriz q tiene dimensiones nx8x6, por lo que esta parte sirve para pasar a dos dimensiones nx6
for i=1:n
    for j=1:6
        aux(i,j)=q(i,1,j);
    end
end
q=aux;
clear aux;
%% velocidad maxima de los ejes
V=[150*pi/180 150*pi/180 150*pi/180 260*pi/180 260*pi/180 400*pi/180];    %<---se define la velocidad maxima con la que se quiere que se mueva las articulaciones

%% Interpolacion en el espacio articular.
% #Se interpola en el espacio articular con los tipos de interpolacion
% lineal, cubico y a tramos. 
if interpolador == 0 % interpolador lineal
    q = lineal(robot,q',5,Res*6);                                         
elseif interpolador == 1 % interpolador a tramos
    q = tramos(robot,q',Res*6);
elseif interpolador == 2 % interpolador cubico
    q = cubico(robot,q',5,Res*6);
else
    error('el interpolador debe ser 0 , 1 o 2')
end

%% Tipo de movimiento
% #Una vez generada los puntos por lo que debe pasar el robot se debe
% escoger que tipo de movimiento se desea en para que el robot pase por 
% esos putnos. Si es tipo = 0 tray. simultanea, 1 tray. coordinada
n=size(q);
n=n(1);
if tipo == 0
    for i=1:n-1
       if i==1
         qTra = simultaneo(q(i,:),q(i+1,:),V,Res);
       else
         qTra = [qTra  simultaneo(q(i,:),q(i+1,:),V,Res)];
       end
    end
elseif tipo ==1
    for i=1:n-1
       if i==1
         qTra = coordinado(q(i,:),q(i+1,:),V,Res);

       else
         qTra = [qTra  coordinado(q(i,:),q(i+1,:),V,Res)];
       end
    end
else
    error('el tipo debe ser 0 o 1')
end

q=qTra';
%% Obtener Velociades y aceleraciones
%velocidad
qd=midiff(q,Res);
qd=[zeros(1,6);qd];
%aceleración
qdd=midiff(qd,Res);
qdd=[zeros(1,6);qdd];
[t e]=size(q);
%% Calculos Dinamicos   
Pext = [[0 0 mi*9.8]' [ 0 0 0]'];
grav = [0 0 9.8];
Tau = zeros(6,t);
for i =1:t
   Tau(:,i)=NEDiIn(robot , q(i,:)' , qd(i,:)' , ...
   qdd(i,:)' , grav , Pext);
end
tau = Tau;

end 