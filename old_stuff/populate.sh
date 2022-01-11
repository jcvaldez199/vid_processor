#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=641 # these are + 1
MAX_HEIGHT=355
MAX_FRAMES=6

HSE_PORT=10000
MONGO_CLIENT=/home/wang/hse-mongo-old/build/opt/mongo/mongo
COLLECTION_NAME="imagetest_normal"


$MONGO_CLIENT --port $HSE_PORT --eval "db.$COLLECTION_NAME.drop();" mydb
counter=5
width=0
height=0
while [ $counter -lt $MAX_FRAMES ]
do

  echo $counter
  while [ $width -lt $MAX_WIDTH ]
  do

    while [ $height -lt $MAX_HEIGHT ]
    do

      #./vidproc/bin/python new_data.py $counter
      GRAY=$(( $RANDOM % 100  ))
      #mongo --port 10000 --eval 'var document = { loc : [0,0], grayscale : 100, frame : 5 }; db.imagetest_normal.insert(document);' mydb
      $MONGO_CLIENT --port $HSE_PORT --eval "var document = { loc : [$width,$height], grayscale : $GRAY, frame : $counter }; db.$COLLECTION_NAME.insert(document);" mydb >/dev/null 2>&1

      ((height++))
    done
    height=0

    ((width++))
  done
  width=0

  ((counter++))
done

