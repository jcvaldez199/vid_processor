import pymongo
import numpy as np
import cv2
import sys

myclient = pymongo.MongoClient("mongodb://localhost:10000")
mydb = myclient["mydb"]
collection = mydb["imagetest_normal"]

def insert_image(frame_count):
    insertlist = []
    cur_frame = frame_count
    frame = gen_image(cur_frame)
    for row, height in enumerate(frame):
        for column, greyval in enumerate(height):
            insertlist.append({"loc":[int(column), int(frame.shape[0])-row],"grayscale":int(greyval),"frame":cur_frame})

    x = collection.insert_many(insertlist)
    cv2.destroyAllWindows()

def gen_image(frame_no):
    image = cv2.imread('minecraft_frame_10.jpg')
    frame = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return frame

if __name__ == '__main__':
    insert_image(int(sys.argv[1]))
    pass
