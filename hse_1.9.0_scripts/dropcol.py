import pymongo

myclient = pymongo.MongoClient("mongodb://localhost:10000")
mydb = myclient["mydb"]
collection = mydb["imagetest_normal"]

def drop_coll():
    collection.drop()

if __name__ == '__main__':
    drop_coll()
    pass
