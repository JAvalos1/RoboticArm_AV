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
  
qA=CineI(r,MTHA) 
qB=CineI(r,MTHB)