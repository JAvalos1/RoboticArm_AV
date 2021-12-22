import cv2
from object_detector import *
import numpy as np

def Vision():
    _, img = cap.read()

        # Get Aruco marker
    corners, _, _ = cv2.aruco.detectMarkers(img, aruco_dict, parameters=parameters)
    if corners:

        # Draw polygon around the marker
        int_corners = np.int0(corners)
        cv2.polylines(img, int_corners, True, (0, 255, 0), 5)

        # Aruco Perimeter
        aruco_perimeter = cv2.arcLength(corners[0], True)

        # Pixel to cm ratio
        pixel_cm_ratio = aruco_perimeter / 20

        contours = detector.detect_objects(img)

        # Draw objects boundaries
        for cnt in contours:
            # Get rect
            rect = cv2.minAreaRect(cnt)
            (x, y), (w, h), angle = rect

            # Get Width and Height of the Objects by applying the Ratio pixel to cm
            object_width = w / pixel_cm_ratio
            object_height = h / pixel_cm_ratio

            # Display rectangle
            box = cv2.boxPoints(rect)
            box = np.int0(box)

            area = object_height*object_width

            cv2.circle(img, (int(x), int(y)), 5, (0, 0, 255), -1)
            cv2.polylines(img, [box], True, (255, 0, 0), 2)
            cv2.putText(img, "Area {}".format(round(area, 1)), (int(x - 100), int(y - 20)), cv2.FONT_HERSHEY_PLAIN, 2, (100, 200, 0), 2)

    #contours = detector.detect_objects(img)

    # Draw objects boundaries
    #for cnt in contours:
        # Get rect
    #    rect = cv2.minAreaRect(cnt)
    #    (x, y), (w, h), angle = rect

        #print(rect)

        # Display rectangle
    #    box = cv2.boxPoints(rect)
    #    box = np.int0(box)

    #    area = cv2.contourArea(cnt)

    #    cv2.circle(img, (int(x), int(y)), 5, (0, 0, 255), -1)
    #    cv2.polylines(img, [box], True, (255, 0, 0), 2)
    #    cv2.putText(img, "Area {}".format(round(area, 1)), (int(x - 100), int(y - 20)), cv2.FONT_HERSHEY_PLAIN, 2, (100, 200, 0), 2)

        ############################################################################################################################
        #CantidadC1 = 0
        #CantidadC2 = 0
        #Ref1 = 4.6 * 10.5
        #Ref2 = 4.6 * 6
        #if area-Ref1 < area-Ref2  #Significa que es mas aproximado a la caja 1
        #   Colocar caja en contenedor 1
        #   BaseDeDatos(C1,CantidadC1)
        #   CantidadC1+=1
        #else
        #   #Colocar caja en contenedor 2
        #   BaseDeDatos(C2,CantidadC2)
        #   CantidadC2+=1
        ############################################################################################################################

    cv2.imshow("Image", img)

# Load Aruco detector
parameters = cv2.aruco.DetectorParameters_create()
aruco_dict = cv2.aruco.Dictionary_get(cv2.aruco.DICT_5X5_50)


# Load Object Detector
detector = HomogeneousBgDetector()

# Load Cap
#cap = cv2.VideoCapture(0)
url = 'http://172.16.213.204:8080/video'
cap = cv2.VideoCapture(url)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

while True:
    #Vision()

    _, img = cap.read()

        # Get Aruco marker
    corners, _, _ = cv2.aruco.detectMarkers(img, aruco_dict, parameters=parameters)
    if corners:

        # Draw polygon around the marker
        int_corners = np.int0(corners)
        cv2.polylines(img, int_corners, True, (0, 255, 0), 5)

        # Aruco Perimeter
        aruco_perimeter = cv2.arcLength(corners[0], True)

        # Pixel to cm ratio
        pixel_cm_ratio = aruco_perimeter / 20

        contours = detector.detect_objects(img)

        # Draw objects boundaries
        for cnt in contours:
            # Get rect
            rect = cv2.minAreaRect(cnt)
            (x, y), (w, h), angle = rect

            # Get Width and Height of the Objects by applying the Ratio pixel to cm
            object_width = w / pixel_cm_ratio
            object_height = h / pixel_cm_ratio

            # Display rectangle
            box = cv2.boxPoints(rect)
            box = np.int0(box)

            area = object_height*object_width

            cv2.circle(img, (int(x), int(y)), 5, (0, 0, 255), -1)
            cv2.polylines(img, [box], True, (255, 0, 0), 2)
            cv2.putText(img, "Area {}".format(round(area, 1)), (int(x - 100), int(y - 20)), cv2.FONT_HERSHEY_PLAIN, 2, (100, 200, 0), 2)

    #contours = detector.detect_objects(img)

    # Draw objects boundaries
    #for cnt in contours:
        # Get rect
    #    rect = cv2.minAreaRect(cnt)
    #    (x, y), (w, h), angle = rect

        #print(rect)

        # Display rectangle
    #    box = cv2.boxPoints(rect)
    #    box = np.int0(box)

    #    area = cv2.contourArea(cnt)

    #    cv2.circle(img, (int(x), int(y)), 5, (0, 0, 255), -1)
    #    cv2.polylines(img, [box], True, (255, 0, 0), 2)
    #    cv2.putText(img, "Area {}".format(round(area, 1)), (int(x - 100), int(y - 20)), cv2.FONT_HERSHEY_PLAIN, 2, (100, 200, 0), 2)

        ############################################################################################################################
        #CantidadC1 = 0
        #CantidadC2 = 0
        #Ref1 = 4.6 * 10.5
        #Ref2 = 4.6 * 6
        #if area-Ref1 < area-Ref2  #Significa que es mas aproximado a la caja 1
        #   Colocar caja en contenedor 1
        #   BaseDeDatos(C1,CantidadC1)
        #   CantidadC1+=1
        #else
        #   #Colocar caja en contenedor 2
        #   BaseDeDatos(C2,CantidadC2)
        #   CantidadC2+=1
        ############################################################################################################################

    cv2.imshow("Image", img)

    key = cv2.waitKey(1)
    if key == 27:
        break


cap.release()
cv2.destroyAllWindows()