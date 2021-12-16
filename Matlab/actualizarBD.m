function [] = actualizarBD(p, pos)
DefRobot
n=[];
o=[];
a=[];
A=[];
ang=atan(p(2)/p(1));
if ang>0
    n=[cos(ang) sin(ang) 0]';
    o=[sin(ang) -cos(ang) 0]';
    a=[0 0 -1]';
else
    n=[cos(ang) -sin(ang) 0]';
    o=[-sin(ang) -cos(ang) 0]';
    a=[0 0 -1]';
end
A=[n o a p';0 0 0 1];
q=CineI(r,A);
q=q(1,:);
q=round(q*180/pi+90);
conn = database('Posiciones Articulares','root','');
insert(conn, 'Valores', {'pos','q1','q2','q3','q4','q5'}, {pos,q(1),q(2),q(3),q(4),q(5)});
%data = select(conn,"SELECT * FROM Valores where id='pos2'")
%data{1,2:end}{1}
%exec(conn,"DELETE FROM Valores WHERE id='pos3'")
close(conn)
end

%[12 12 6]

