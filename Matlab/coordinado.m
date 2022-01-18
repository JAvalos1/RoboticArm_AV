function [qr, deltaPasos] = coordinado(qi,qf,Vel,Res)
diferencia=(qf-qi);
tiempos=abs(diferencia)./Vel;
tiempo = max(tiempos);
pasos=ceil(tiempo/Res);

deltaPasos=diferencia./pasos;
qr=zeros(pasos+1,6);
for i=1:6
    qr(:,i)=qi(i):deltaPasos(i):qf(i);
end
qr=qr';
end