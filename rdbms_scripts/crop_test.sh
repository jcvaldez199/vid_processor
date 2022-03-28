#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=10

TABLE_NAME=picture
DATABASE_NAME=gpstest

echo "Executing random crop queries...";
> resfile
repeater=1
while [ $repeater -lt 100 ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    BOTTOM_X=$(( $RANDOM % $MAX_WIDTH  ))
    BOTTOM_Y=$(( $RANDOM % $MAX_HEIGHT ))
    TOP_X=$(( $BOTTOM_X + $RANDOM % ($MAX_WIDTH - $BOTTOM_X) ))
    TOP_Y=$(( $BOTTOM_Y + $RANDOM % ($MAX_HEIGHT - $BOTTOM_Y) ))

    QUERY_STRING="18s/.*/PERFORM grayscale FROM $TABLE_NAME WHERE ST_Within(coord, ST_GeomFromText('POLYGON(($BOTTOM_X $BOTTOM_Y, $BOTTOM_X $TOP_Y, $TOP_X $TOP_Y, $TOP_X $BOTTOM_Y, $BOTTOM_X $BOTTOM_Y))')) AND frame = $counter;/g"

    sed -i "$(echo $QUERY_STRING)" ./test.sql
    ((counter++))
    psql -d $DATABASE_NAME -f ./test.sql >> resfile 2>&1
  done
  ((repeater++))
done

sed -i '/DO/c\' resfile
sed -i 's/psql:.\/test.sql:24: NOTICE://g' resfile
sed -i 's/ //g' resfile
echo "Done!";

echo "Generating time measurement file (postgres) ..."
echo "Results : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " resfile
echo "Max 3 latencies:"
sort -n -r resfile | head -10
