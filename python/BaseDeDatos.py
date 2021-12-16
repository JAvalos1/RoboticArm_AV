import mysql.connector
import serial, time
 
#Conexión con el servidor MySQL Server
conexionMySQL = mysql.connector.connect(
    host='localhost',
    user='root',
    passwd='',
    db='posart'
)
 
#Aca podria ser un switch case
Secuencia=['Pos0','Pos2','Pos1','pick','Pos2','Pos3','Pos4','place','Pos3','Pos0']

arduino = serial.Serial("COM5", 9600)
time.sleep(2)

for i in Secuencia:
    print(i)
    if i=='pick':
        arduino.write('pick'.encode())
        flag=0
        while flag==0:
            rawString = arduino.readline()
            print(rawString)
            if rawString=='Completado\r\n'.encode():
                flag=1
    elif i=='place':
        arduino.write('place'.encode())
        flag=0
        while flag==0:
            rawString = arduino.readline()
            print(rawString)
            if rawString=='Completado\r\n'.encode():
                flag=1
    else:
        #Establecemos un cursor para la conexión con el servidor MySQL
        cursor = conexionMySQL.cursor()
        #A partir del cursor, ejecutamos la consulta SQL de eliminación
        #cursor.execute(sqlEliminarRegistro)
        #conexionMySQL.commit()
        
        #Consulta de selección para mostrar los registros por pantalla
        #para comprobar que se ha eliminado correctamente
        sqlSelect = """SELECT * FROM valores WHERE pos='{}'""".format(i)
        #A partir del cursor, ejecutamos la consulta SQL
        cursor.execute(sqlSelect)
        #Guardamos el resultado de la consulta en una variable
        resultadoSQL = cursor.fetchall()
        #Cerramos el cursor y la conexión con MySQL
        cursor.close()

        #Mostramos el resultado por pantalla
        print (('S{}'.format(1)+str(resultadoSQL[0][2])).encode())

        for j in range(5):
            print(('s{}'.format(j+1)+str(resultadoSQL[0][j+1])).encode())
            arduino.write(('s{}'.format(j+1)+str(resultadoSQL[0][j+1])).encode())
            flag=0
            while flag==0:
                rawString = arduino.readline()
                print(rawString)
                if rawString=='Completado\r\n'.encode():
                    flag=1

conexionMySQL.close()    
arduino.close()