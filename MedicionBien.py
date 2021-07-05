import cv2
from object_detector import *
import numpy as np
from pyzbar.pyzbar import decode

#Se carga el detector de marca
parameters = cv2.aruco.DetectorParameters_create()
aruco_dict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_50)

#Se carga el detector de objetos
detector = HomogeneousBgDetector()

#Se carga la imagen
#img = cv2.imread("phone_aruco_marker.jpg")
#Se carga el video
url = 'http://192.168.43.1:8080/video'
cap = cv2.VideoCapture(url)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 720)

while True:
    _, img = cap.read()

    #Se detecta el marcador
    corners, _, _ = cv2.aruco.detectMarkers(img, aruco_dict, parameters= parameters)

    #Para estimar el tamanho en cm
    if corners:
        print(corners)
        #Se dibuja un poligono alrededor del marcador
        int_corners = np.int0(corners)
        cv2.polylines(img, int_corners, True, (0,255,0), 5)

        #Perimetro del marcador
        aruco_perimeter = cv2.arcLength(corners[0], True)
        #print(aruco_perimeter)

        #Ratio entre cm y pixeles
        pixel_cm_ratio = aruco_perimeter / 20
        #print(pixel_cm_ratio)

        contours = detector.detect_objects(img)

        for cnt in contours:
            #Dibuja un poligono
            #cv2.polylines(img, [cnt], True, (255,0,0), 2)

            #Dibuja un rectangulo
            rect = cv2.minAreaRect(cnt)
            (x, y), (w, h), angle = rect

            #Se transforma el tamanho de pixels a cm con el ratio
            ancho = w / pixel_cm_ratio
            largo = h / pixel_cm_ratio

            #Dibuja un punto en el centro del objeto
            cv2.circle(img, (int(x), int(y)), 5, (0, 0, 255), -1)
            #Crea un contorno para la figura con sus caracteristicas
            box = cv2.boxPoints(rect)
            box = np.int0(box)
            #Dibuja el rectangulo alrededor del objeto
            cv2.polylines(img, [box], True, (255,0,0), 2)
            cv2.putText(img, "Ancho {} cm".format(round(ancho, 1)), (int(x-100), int(y-30)), cv2.FONT_HERSHEY_SIMPLEX, 1, (100, 200, 0), 2)
            cv2.putText(img, "Largo {} cm".format(round(largo, 1)), (int(x-100), int(y+30)), cv2.FONT_HERSHEY_SIMPLEX, 1, (100, 200, 0), 2)
            print(box)

    #Podemos crear una variable donde se guarden lo que contiene el QR
    id = []
    medic = []
    cant = []

    #Para leer el codigo QR
    for barcode in decode(img):
        #print(barcode.data)
        myData = barcode.data.decode('utf-8')
        id = myData.split(':')[0]
        medic = myData.split(':')[1]
        cant = myData.split(':')[2]
        #print(myData)
        pts = np.array([barcode.polygon],np.int32)
        pts = pts.reshape((-1,1,2))
        pts2=barcode.rect
        cv2.polylines(img,[pts],True, (255,0,0), 2)
        cv2.putText(img,myData,(pts2[0],pts2[1]),cv2.FONT_HERSHEY_SIMPLEX,0.9,(255,0,255),2)
    cv2.imshow("Image", img)
    key = cv2.waitKey(1)
    if key == 27:
        break

cap.release()
cv2.destroyAllWindows()
