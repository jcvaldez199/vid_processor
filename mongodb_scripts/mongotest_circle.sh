#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=10
COLLECTION_NAME=imagetest_normal

echo "Getting start time...";
START_TIME=$(date --iso-8601=seconds)
echo "Starting time : $START_TIME"

echo "Executing random crop queries...";

repeater=1
while [ $repeater -lt 100 ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    CENTER_X=$(( $RANDOM % $MAX_WIDTH  ))
    CENTER_Y=$(( $RANDOM % $MAX_HEIGHT ))
    RADIUS=$(( $RANDOM % (($MAX_WIDTH>$MAX_HEIGHT ? $MAX_HEIGHT : $MAX_WIDTH)/ 2)))
    # normal mongo
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$center:[[$CENTER_X,$CENTER_Y],$RADIUS]} }, frame:$counter });" mydb >/dev/null 2>&1
    echo $RADIUS

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

echo "Generating time measurement file (normal mongo) ..."
mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} );" mydb \
  | sed 1,4d \
  | sed 's/[^0-9]*//g' > resfile
echo "Results : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " resfile
echo "Max 3 latencies:"
sort -n -r resfile | head -10

