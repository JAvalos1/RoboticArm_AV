function [tau, R]=NEDiIn(q, qd, qdd, grav, pext)
% tau=NEDiIn(robot, q,qd,qdd,grav,pext)
% robot: objeto robot
% q=vector 6x1 que representa el estado de las variables articulares
% qd=vector 6x1 que representa la velociad angular
% qdd=vector 6x1 que representa la aceleracion angular
% grav=vector 1x3  que representa la gravedad
% pext=vector de 3x2 que que representa la fuerza y par ejercidos sobre la
% herramienta
% tau=vector 1x6 que representa los pares ejercidos sobre las
% articulaciones

%%%%%%%Cosas para cambiar de acuerdo al ejercicio%%%%%%%%%%%%%%%%
% Parametros DH (d, a, alpha, offset), el tipo de articulaciones (tipo)
% el numero de articulaciones n, las matrices s de coordenadas del centro
% de masa del eslabon i respecto al sistema Si, las matrices I para c/u,
% las masas,
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms pix m1 m2 m3 m4 theta L1 L2 a1 d1 d2 theta1 theta2 theta1d theta2d theta1dd theta2dd theta3 theta4 theta3d theta4d theta3dd theta4dd g;
% NE1
d=[L1 q(2) q(3) L2];
a=[0 -a1 0 0];
alpha=[0 -pi/2 0 0];
offset=[0 0 0 0];
tipo=[0 1 1 0]; %Tipo de articulación 0->rotativo, 1->prismatico
n=4;
M=[m1 m2 m3 m4];
S=[0 0 -L1/2;a1 -q(2)/2 0;0 0 -q(3)/2;0 0 -L2/2];
% NE2
%R=zeros(3,3,2);
for i=1:n
    if tipo(i)==0
        aux=denavit(q(i)+offset(i),d(i),a(i),alpha(i));
        R(:,:,i)=simplify(aux(1:3,1:3));
    else
        aux=denavit(0,q(i),a(i),alpha(i));
        R(:,:,i)=simplify(aux(1:3,1:3));
    end
    
end

% NE3
w0=zeros(1,3)';
wd0=zeros(1,3)';
v0=zeros(1,3)';
vd0=transpose(-grav);
z0=[0 0 1]';
% p=zeros(3,6);
% s=zeros(3,6);
% I=zeros(3,3,6);
% m=zeros(1,6);
for i=1:n
    p(:,i)=[a(i) d(i)*sin(alpha(i)) d(i)*cos(alpha(i))];
end

aux=[];
for i=1:n
    aux=transpose(S);
    s(:,i)=aux(:,i);   %%%%AGREGAR SEGUN HAGA FALTA
%s(:,2)=transpose([0 0 0]);

    I(:,:,i)=zeros(3,3);                %%ESTE TAMBIEN
%I(:,:,2)=zeros(3,3);

    m(i)=M(i);                            %%Y ESTE
%m(2)=m2;
end

% NE4
% w=zeros(3,6);
for i=1:n
    if i==1
        if (tipo(i)==0)
            w(:,i)=transpose(R(:,:,i))*(w0+z0*qd(i));
        else
            w(:,i)=transpose(R(:,:,i))*w0;
        end
    else
        if (tipo(i)==0)
            w(:,i)=transpose(R(:,:,i))*(w(:,i-1)+z0*qd(i));
        else 
            w(:,i)=transpose(R(:,:,i))*w(:,i-1);
        end
    end
end
% NE5
% wd=zeros(3,6);
for i=1:n
    if i==1
        if tipo(i)==0
            wd(:,i)=transpose(R(:,:,i))*(wd0+z0*qdd(i))+cross(w0,z0*qd(i));
        else 
            wd(:,i)=transpose(R(:,:,i))*wd0;
        end
        
    else
        if tipo(i)==0
            wd(:,i)=transpose(R(:,:,i))*(wd(:,i-1)+z0*qdd(i))+cross(w(:,i-1),z0*qd(i));
        else 
            wd(:,i)=transpose(R(:,:,i))*wd(:,i-1);
        end
        
    end
end

% NE6
% vd=zeros(3,6);
for i=1:n
    if i==1
        if tipo(i)==0
            vd(:,i)=cross(wd(:,i),p(:,i))+cross(w(:,i),cross(w(:,i),p(:,i)))...
            +transpose(R(:,:,i))*vd0;
        else
            vd(:,i)=transpose(R(:,:,i))*(z0*qdd(i)+vd0)+cross(wd(:,i),p(:,i))...
                +2*cross(w(:,i),transpose(R(:,:,i))*z0*qd(i))+...
                cross(w(:,i),cross(w(:,i),p(:,i)));
        end
        
    else
        if tipo(i)==0
            vd(:,i)=cross(wd(:,i),p(:,i))+cross(w(:,i),cross(w(:,i),p(:,i)))...
            +transpose(R(:,:,i))*vd(:,i-1);
        else 
            vd(:,i)=transpose(R(:,:,i))*(z0*qdd(i)+vd(:,i-1))+cross(wd(:,i),p(:,i))...
                +2*cross(w(:,i),transpose(R(:,:,i))*z0*qd(i))+...
                cross(w(:,i),cross(w(:,i),p(:,i)));
        end
 
    end
end

% NE7
% ai=zeros(3,6);

for i=1:n
    ai(:,i)=cross(wd(:,i),s(:,i))+cross(w(:,i),cross(w(:,i),s(:,i)))+vd(:,i);
end

% NE8
% f=zeros(3,6);
fext=pext(:,1);
for i=n:-1:1
    if i==n
        f(:,i)=eye(3,3)*fext+m(i)*ai(:,i);
    else
        f(:,i)=R(:,:,i+1)*f(:,i+1)+m(i)*ai(:,i);
    end
end
% NE9
% n=zeros(3,6);
next=pext(:,2);
for i=n:-1:1
    if i==n
        ni(:,i)=eye(3,3)*(next+cross(eye(3,3)*p(:,i),fext))+...
            cross((p(:,i)+s(:,i)),m(:,i)*ai(:,i))+...
            I(:,:,i)*wd(:,i)+cross(w(:,i),I(:,:,i)*w(:,i));
    else
        ni(:,i)=R(:,:,i+1)*(ni(:,i+1)+cross(transpose(R(:,:,i+1))*p(:,i),f(:,i+1)))+...
            cross((p(:,i)+s(:,i)),m(:,i)*ai(:,i))+...
            I(:,:,i)*wd(:,i)+cross(w(:,i),I(:,:,i)*w(:,i));
    end
end

% NE10
% tau=zeros(1,6);
for i=n:-1:1
    if(tipo(i)==0)
        tau(i)=transpose(ni(:,i))*transpose(R(:,:,i))*z0;
    else
        tau(i)=transpose(f(:,i))*transpose(R(:,:,i))*z0;
    end
    
end

end

