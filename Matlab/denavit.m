function dh=denavit(teta, d, a, alfa)
syms pix d2 m1 m2 theta L1 theta1 theta2 theta1d theta2d theta1dd theta2dd;
if alfa==pix/2
    cosalfa=0;
    sinalfa=1;
elseif alfa==-pix/2
    cosalfa=0;
    sinalfa=-1;
elseif alfa==0;
    cosalfa=1;
    sinalfa=0;
elseif alfa==pix
    cosalfa=-1;
    sinalfa=0;
else 
    cosalfa=cos(alfa);
    sinalfa=sin(alfa);
end
dh=[cos(teta)  -cosalfa*sin(teta)   sinalfa*sin(teta)   a*cos(teta);
    sin(teta)   cosalfa*cos(teta)  -sinalfa*cos(teta)   a*sin(teta);
           0              sinalfa             cosalfa             d;
           0                     0                     0              1;];
end