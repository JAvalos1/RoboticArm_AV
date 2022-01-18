%% Para este ejemplo vamos a mover el brazo de un punto a otro.

PA=[0 0.25 0];
PB=[-0.25 0.1 0];
MTHA=[1 0 0 PA(1);
      0 -1 0 PA(2);
      0 0 -1 PA(3);
      0 0 0 1];
  
MTHB=[1 0 0 PB(1);
      0 -1 0 PB(2);
      0 0 -1 PB(3);
      0 0 0 1];
qA=CineI(r,MTHA);  
qB=CineI(r,MTHB);
Vel=[90 90 90 90 90 90]*pi/180;
Res=0.02;
qr=simultaneo(qA, qB, Vel, Res)
qr2=coordinado(qA,qB,Vel,Res)
trplot(MTHA)
hold on
trplot(MTHB)
%Curva=1: Linea
%Curva=2: Cia
curva=1;
  [noap_herramienta n]=GenerarTrayecto(MTHA, MTHB,curva);
  mi=[0 0 0];
  tipo=1;
  interpolador=1;
  [q, qd, qdd, tau] = Trayectoria(r,mi, tipo, noap_herramienta, Res, interpolador)
  
