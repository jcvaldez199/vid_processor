#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=11

#MONGODB
COLLECTION_NAME=imagetest_normal

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest
> mongoresfile

echo "Executing random crop queries...";

repeater=0
while [ $repeater -lt 100 ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));
    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')
    BOTTOM_X=$(( $RANDOM % $MAX_WIDTH  ))
    BOTTOM_Y=$(( $RANDOM % $MAX_HEIGHT ))
    TOP_X=$(( $BOTTOM_X + $RANDOM % ($MAX_WIDTH - $BOTTOM_X) ))
    TOP_Y=$(( $BOTTOM_Y + $RANDOM % ($MAX_HEIGHT - $BOTTOM_Y) ))

    # normal mongo
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$box:[[$BOTTOM_X,$BOTTOM_Y],[$TOP_X,$TOP_Y]]} }, frame:$counter });" mydb >/dev/null 2>&1

    mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} );" mydb \
      | sed 1,4d \
      | sed 's/[^0-9]*//g' >> mongoresfile

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

echo "Results : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " mongoresfile
echo "Max 10 latencies:"
sort -n -r mongoresfile | head -10

