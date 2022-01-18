function [Ja, A]=Jacobiano(r,q)
d = r.d;
a = r.a;
alpha = r.alpha;
offset = r.offset;

tipo=[0 0 0 0 0 0]; %Tipo de articulación 0->rotativo, 1->prismatico
n = 6; %cantidad de qs

%% Se definen las matrices de transformacion i-1Ai
for i=1:n
    if tipo(i)==0
        aux=denavit(q(i)+offset(i),d(i),a(i),alpha(i));
        A(:,:,i)=aux;
    else
        aux=denavit(0,q(i),a(i),alpha(i));
        A(:,:,i)=aux;
    end
end

%% Se inicializa la matriz que contendra los valores
Ja = zeros(6,n);
%% Se eligen los vectores zi y pi de las matices de transformacion
for i=1:n
    if tipo(i) == 1  %articulacion prismatica, se define la rotacion diferente
        R = cA(A,0,i-1);
        R = R(1:3,1:3);
        Ja(1:3,i) = R*[0;0;1]; %Jv, vector de velocidad lineal
        Ja(4:6,i) = [0;0;0]; %Jw, vector de velocidad angular
    else            %articulacion rotativa
        R = cA(A,0,i-1);     %se llama a una funcion externa que calcula las matrices intermedias
        R = R(1:3,1:3);
        An = cA(A,0,n);
        dn = An(1:3,4:4);
        A1 = cA(A,0,i-1);
        d1 = A1(1:3,4:4);
        Ja(1:3,i) = cross(R*[0;0;1] , (dn-d1)); % Jv
        Ja(4:6,i )= R*[0;0;1]; %Jw
    end
end

end