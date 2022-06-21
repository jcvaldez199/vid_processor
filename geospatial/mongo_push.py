import numpy as np
import sys

import pymongo
import json

import gc

def populate():
    frame_max = 101

    myclient = pymongo.MongoClient()
    mydb = myclient["mydb"]
    collection = mydb["imagetest_normal"]

    with open("datafile.json") as f:
        data  = json.load(f)
        for cnt in range(1, frame_max):
            newone = [
                {"loc":x["loc"], "grayscale":x["grayscale"], "frame":cnt}
                for x in data
            ]
            collection.insert_many(newone)
            print(cnt)
            del newone
            gc.collect()


if __name__ == '__main__':
    populate()
