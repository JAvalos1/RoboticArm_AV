function qr=simultaneo(qi, qf, Vel, Res)
diferencia=qf-qi;
tiempos=abs(diferencia)./Vel;
pasos=ceil(tiempos/Res);
for i=1:6
    if pasos(i)==0
        pasos(i)=1;
    end
end
pasoMayor=max(pasos);
deltaPasos=diferencia./pasos;
qr=zeros(pasoMayor+1,6);
for i=1:6
    qr(1:pasos(i)+1,i)=qi(i):deltaPasos(i):qf(i);
end
qr=qr';
end