import numpy as np
import cv2
import sys
import json

def insert_image(frame_count):
    insertlist = []
    cur_frame = frame_count
    frame = gen_image()

    # squeeze coordinates into lat/lon domain
    lat_distance = 180/float(frame.shape[0]-1) # latitude per pixel height
    lon_distance = 360/float(frame.shape[1]-1) # longitude per pixel width
    curr_lat = 0

    for row, height in enumerate(frame):
        curr_lat = 90.0 - float(lat_distance*row)

        for column, greyval in enumerate(height):
            curr_lon = 180 - float(lon_distance*column)
            # mongodb takes (lon,lat) not the usual
            insertlist.append({"loc":{"type":"Point", "coordinates":[curr_lon, curr_lat]},"grayscale":int(greyval),"frame":0})
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
