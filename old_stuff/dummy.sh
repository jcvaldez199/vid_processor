#!/bin/bash

#constants
BASE_FRAME=5
MAX_FRAMES=2000

HSE_PORT=10000 # real hse port
#HSE_PORT=16000
MONGO_CLIENT=/home/wang/hse-mongo-old/build/opt/mongo/mongo
COLLECTION_NAME="imagetest_normal"


# reset the database
$MONGO_CLIENT --port $HSE_PORT --eval "db.$COLLECTION_NAME.drop();" mydb >/dev/null 2>&1
#./vidproc/bin/python generate.py 

# insert
./vidproc/bin/python pushdata.py $HSE_PORT $MAX_FRAMES

#counter=5
#while [ $counter -lt $MAX_FRAMES ]
#do
#  echo $counter
#      #cat datafile | sed "s/'//g" > insertfile
#      #mongo --eval "var document = $(cat insertfile); db.$COLLECTION_NAME.insert(document);" mydb 
#      #mongo  127.0.0.1/mydb script.js
#  ((counter++))
#done
#
