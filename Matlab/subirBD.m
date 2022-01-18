clear all
close all
clc
function v=subirBD(A,q)
conn = database('Posiciones Articulares','root','');
insert(conn, 'Valores', {'id','q1','q2','q3','q4','q5'}, {A,q(1),q(2),q(3),q(4),q(5)});
%data = select(conn,"SELECT * FROM Valores where id='pos2'")
%data{1,2:end}{1}
%exec(conn,"DELETE FROM Valores WHERE id='pos3'")
close(conn)
end