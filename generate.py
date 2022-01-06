import numpy as np
import cv2
import sys
import json

def insert_image(frame_count):
    insertlist = []
    cur_frame = frame_count
    frame = gen_image()
    for row, height in enumerate(frame):
        for column, greyval in enumerate(height):
            insertlist.append({"loc":[int(column), int(frame.shape[0])-row],"grayscale":int(greyval),"frame":0})

    #print(insertlist, file=open("datafile.json", "w"))
    with open('datafile.json', 'w') as f:
        json.dump(insertlist, f)

    cv2.destroyAllWindows()

def gen_image():
    image = cv2.imread('constant_img.jpg')
    frame = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return frame

if __name__ == '__main__':
    insert_image(0)
    pass
