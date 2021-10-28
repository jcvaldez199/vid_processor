#!/bin/bash

#constants
BASE_FRAME=20100
MAX_WIDTH=320
MAX_HEIGHT=240
MAX_FRAMES=10


echo "Getting start time...";
START_TIME=$(date --iso-8601=seconds)
echo "Starting time : $START_TIME"

echo "Executing random crop queries...";

counter=0
while [ $counter -lt $MAX_FRAMES ]
do
  BOTTOM_X=$(( $RANDOM % $MAX_WIDTH  ))
  BOTTOM_Y=$(( $RANDOM % $MAX_HEIGHT ))
  TOP_X=$(( $BOTTOM_X + $RANDOM % ($MAX_WIDTH - $BOTTOM_X) ))
  TOP_Y=$(( $BOTTOM_Y + $RANDOM % ($MAX_HEIGHT - $BOTTOM_Y) ))
  mongo --eval "db.imagetest.find({ loc : { \$geoWithin : {\$box:[[$BOTTOM_X,$BOTTOM_Y],[$TOP_X,$TOP_Y]]} }, frame:$(($BASE_FRAME + $counter)) });" mydb >/dev/null 2>&1

  ((counter++))
done

echo "Done!";

echo "Generating time measurement file..."
mongo --eval "db.system.profile.find( { ns : 'mydb.imagetest', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} );" mydb \
  | sed 1,4d \
  | sed 's/[^0-9]*//g' > resfile
echo "Results : "
#awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " resfile
echo "Max 3 latencies:"
sort -n -r resfile | head -3
