#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

echo "Executing random crop queries...";

COLLECTION_NAME=imagetest_normal
repeater=0
max_repeats=10
MAX_FRAMES=101
while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    line_num=$(($repeater*$MAX_FRAMES + $counter));
    #echo $line_num
    center=$(sed "$line_num q;d" mongo_rands_radial_center;)
    radius=$(sed "$line_num q;d" mongo_rands_radial_radius;)

    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$nearSphere : { \$geometry : { type:\"Point\", coordinates : $center }, \$maxDistance : $radius } }, frame:$counter });" mydb > /dev/null 2>&1
    time_val=$(mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb)
    time_out=$(echo $time_val \
      | sed 1,4d \
      | sed 's/[^0-9]*//g')
    
    if [[ "$time_out" == *"503"* ]]; then
      echo "503 found at $center, $radius, $START_TIME"
      echo $time_val
    fi


    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$near : { \$geometry : { type:\"Point\", coordinates : $center }, \$maxDistance : $radius } }, frame:$counter });" mydb > /dev/null 2>&1
    time_val=$(mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb)
    time_out=$(echo $time_val \
      | sed 1,4d \
      | sed 's/[^0-9]*//g')

    if [[ "$time_out" == *"503"* ]]; then
      echo "503 found at $center, $radius, $START_TIME"
      echo $time_val
    fi

    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$centerSphere:[$center,$radius/6378000]} }, frame:$counter });" mydb > /dev/null 2>&1
    time_val=$(mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb)
    time_out=$(echo $time_val \
      | sed 1,4d \
      | sed 's/[^0-9]*//g')

    if [[ "$time_out" == *"503"* ]]; then
      echo "503 found at $center, $radius, $START_TIME"
      echo $time_val
    fi

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

