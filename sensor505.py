SENS = 23

import sys
import RPi.GPIO as GPIO
from time import sleep

import cv2

cam = cv2.VideoCapture(0)

GPIO.setmode(GPIO.BCM)
GPIO.setup(SENS, GPIO.IN)
while True:
    value = GPIO.input(SENS)
    if value:
	    ret, img = cam.read()
	    cv2.imshow('my_cam', img)
    if cv2.waitKey(10) == 27:
	    break
    print(value)
cam.release()
cv2.destroyAllWindows()
print("done")
GPIO.cleanup()
