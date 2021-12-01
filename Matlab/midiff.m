
function res = midiff(q,t) 
%recibe una matriz de la forma q=[q1; q2; q3;...;qm] y devuele la una
%matriz de la forma qd =[qd1; qd2 ;...;qdm-1] correspondiente a la 
%diferenciacion de q
    [nn n]=size(q);
    res=zeros(nn-1,n);
    for i=1:nn-1
        res(i,:)=(q(i+1,:)-q(i,:))/t;
    end
end