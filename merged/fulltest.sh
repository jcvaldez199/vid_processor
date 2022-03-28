#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=10

#MONGODB
COLLECTION_NAME=imagetest_normal

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongoresfile
> postgresresfile

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
    BOTTOM_X=$(( $RANDOM % $MAX_WIDTH  ))
    BOTTOM_Y=$(( $RANDOM % $MAX_HEIGHT ))
    TOP_X=$(( $BOTTOM_X + $RANDOM % ($MAX_WIDTH - $BOTTOM_X) ))
    TOP_Y=$(( $BOTTOM_Y + $RANDOM % ($MAX_HEIGHT - $BOTTOM_Y) ))

    # normal mongo
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$box:[[$BOTTOM_X,$BOTTOM_Y],[$TOP_X,$TOP_Y]]} }, frame:$counter });" mydb >/dev/null 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM $TABLE_NAME WHERE ST_Within(coord, ST_GeomFromText('POLYGON(($BOTTOM_X $BOTTOM_Y, $BOTTOM_X $TOP_Y, $TOP_X $TOP_Y, $TOP_X $BOTTOM_Y, $BOTTOM_X $BOTTOM_Y))')) AND frame = $counter;/g"

    sed -i "$(echo $QUERY_STRING)" ./test.sql
    ((counter++))
    psql -d $DATABASE_NAME -f ./test.sql >> postgresresfile 2>&1
  done
  ((repeater++))
done

echo "Done!";

echo "Generating time measurement file (normal mongo) ..."
mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb \
  | sed 1,4d \
  | sed 's/[^0-9]*//g' > mongoresfile
echo "Results : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " mongoresfile
echo "Max 10 latencies:"
sort -n -r mongoresfile | head -10

sed -i '/DO/c\' postgresresfile
sed -i 's/psql:.\/test.sql:24: NOTICE://g' postgresresfile
sed -i 's/ //g' postgresresfile
echo "Done!";

echo "Generating time measurement file (postgres) ..."
echo "Results : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " postgresresfile
echo "Max 3 latencies:"
sort -n -r postgresresfile | head -10