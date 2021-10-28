import pymongo
import numpy as np
import cv2

myclient = pymongo.MongoClient("mongodb://localhost:27017")
mydb = myclient["mydb"]
collection = mydb["imagetest"]

def drop_coll():
    collection.drop()

def insert_image():
    fname = "./cow.jpg"
    frame = cv2.imread(fname, cv2.IMREAD_GRAYSCALE)
    insertlist = []
    for row, height in enumerate(frame):
        for column, greyval in enumerate(height):
            insertlist.append({"loc":[int(column), int(frame.shape[0])-row],"grayscale":int(greyval)})

    x = collection.insert_many(insertlist)
    cv2.destroyAllWindows()

def insert_index(shape):
    collection.create_index([("loc",pymongo.GEO2D),("loc",pymongo.ASCENDING),("min",0),("max",max(shape))])

def query_crop(shape):
    bot_left = 300
    upper_right = 500
    img_array = []
    for row in range(upper_right, bot_left, -1):
        query = { "loc" :
                 { "$geoWithin" :
                  { "$box" : [[bot_left,row],[upper_right,row]]
                   }
                  }
                 }
        mydoc = collection.find(query,{"grayscale":1})
        raw_array = []
        for x in mydoc:
            raw_array.append(x['grayscale'])
        if len(img_array) == 0:
            img_array = np.array([raw_array],dtype=np.uint8)
        else:
            img_array = np.append(img_array,np.array([raw_array],dtype=np.uint8),axis=0)

    return img_array

def print_img(frame):
    print(frame.shape)
    cv2.imwrite('test_image.jpg',frame)
    cv2.destroyAllWindows()

if __name__ == '__main__':
    drop_coll()
    insert_image()
    #insert_index((1064,1600))
    #img = query_crop((1064,1600))
    #print_img(img)
    pass
