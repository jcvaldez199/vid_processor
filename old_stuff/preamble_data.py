import pymongo
import numpy as np
import cv2
import sys

myclient = pymongo.MongoClient("mongodb://localhost:16000")
mydb = myclient["mydb"]
collection = mydb["imagetest_normal"]
video_name = "minecraft.mp4"
cap = cv2.VideoCapture(video_name)
max_frames = 1000
frame_multiplier = 1
starting_frame = 5

def drop_coll():
    collection.drop()

def insert_image(frame_count):
    for x in range(frame_count):
        insertlist = []
        cur_frame = starting_frame+frame_multiplier*x
        frame = gen_frame(cur_frame)
        for row, height in enumerate(frame):
            for column, greyval in enumerate(height):
                insertlist.append({"loc":[int(column), int(frame.shape[0])-row],"grayscale":int(greyval),"frame":cur_frame})

        x = collection.insert_many(insertlist)
        cv2.destroyAllWindows()

def gen_image(frame_no):
    image = cv2.imread('minecraft_frame_10.jpg')
    frame = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return frame

def gen_frame(frame_no):
    cap.set(cv2.CAP_PROP_POS_FRAMES, frame_no)
    ret, frame = cap.read()
    frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    my_video_name = video_name.split(".")[0]
    cv2.imwrite(my_video_name+'_frame_'+str(frame_no)+'.jpg',frame)
    return frame

if __name__ == '__main__':
    drop_coll()
    insert_image(max_frames)
    pass
