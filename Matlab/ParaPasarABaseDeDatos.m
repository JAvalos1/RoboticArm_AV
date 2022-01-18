clear all
close all
clc
conn = database('Posiciones Articulares','root','');
insert(conn, 'Valores', {'id','q1','q2','q3','q4'}, {'pos3','a','b','c','d'});

data = select(conn,"SELECT * FROM Valores where id='pos2'")

data{1,2:end}{1}

exec(conn,"DELETE FROM Valores WHERE id='pos3'")

%close(conn)