function A=cA(A,i,j)
 ii=i;
 jj=j;
    if i==j
        aux = eye(4);
    else
        aux = eye(4);
        if i>j
            i=j;
            j=ii;
        end
        for ki=i+1:j
            aux = aux * A(:,:,ki);
        end
        if ii>jj
            aux = transpose(aux);
        else
            aux = aux;
        end
    end
    A = aux;
end