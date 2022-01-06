import pymongo
import numpy as np
import cv2

# image is HxW

myclient = pymongo.MongoClient("mongodb://localhost:27017")

dblist = myclient.list_database_names()
if "mydb" in dblist:
  print("The database exists.")

mydb = myclient["mydb"]
collection = mydb["frame20100"]

#Open the video file
video_name = "top_500_cheese.mp4"
cap = cv2.VideoCapture(video_name)

"""
        START OF BLOCK

        LOOP THIS BLOCK TO
        RETRIEVE FRAME-BY-FRAME
"""
frame_no = 20100
cap.set(cv2.CAP_PROP_POS_FRAMES, frame_no)

#Read the next frame from the video. If you set frame 749 above then the code will return the last frame.
ret, frame = cap.read()
frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
print(frame.shape)

#Cut the video extension to have the name of the video
my_video_name = video_name.split(".")[0]

#Store this frame to an image
cv2.imwrite(my_video_name+'_frame_'+str(frame_no)+'.jpg',frame)


"""
  END OF BLOCK
"""

"""
    NOW USE frame AS 2D PLANE
"""
insertlist = []
for row, height in enumerate(frame):
    for column, greyval in enumerate(height):
        insertlist.append({"loc":[int(column), int(frame.shape[0])-row],"grayscale":int(greyval)})

x = collection.insert_many(insertlist)
print(x.inserted_ids)





# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()
