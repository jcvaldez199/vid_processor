#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

> ./mongo_results/mongoresfile

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
    echo $line_num
    polygon=$(sed "$line_num q;d" mongo_rands_2d;)

    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')

    # normal mongo
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$$polygon} }, frame:$counter });" mydb >/dev/null 2>&1

    # retrieve mongo query
    mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb \
      | sed 1,4d \
      | sed 's/[^0-9]*//g' >> ./mongo_results/mongoresfile

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

echo "Results (mongodb) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " ./mongo_results/mongoresfile
echo "Max 10 latencies:"
sort -n -r ./mongo_results/mongoresfile | head -10
