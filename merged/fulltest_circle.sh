#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

#MONGODB
COLLECTION_NAME=imagetest_normal

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongoresfile
> postgresresfile

echo "Executing random crop queries...";

repeater=0
while [ $repeater -lt 100 ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));
    START_TIME=$(date --iso-8601=ns | sed 's/,/./g')
    CENTER_X=$(( $RANDOM % $MAX_WIDTH  ))
    CENTER_Y=$(( $RANDOM % $MAX_HEIGHT ))
    RADIUS=$(( $RANDOM % (($MAX_WIDTH>$MAX_HEIGHT ? $MAX_HEIGHT : $MAX_WIDTH)/ 2)))

    # normal mongo
    mongo --eval "db.$COLLECTION_NAME.find({ loc : { \$geoWithin : {\$center:[[$CENTER_X,$CENTER_Y],$RADIUS]} }, frame:$counter });" mydb >/dev/null 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM $TABLE_NAME WHERE ST_DFullyWithin(coord, ST_GeomFromText('POINT($CENTER_X $CENTER_Y)'), $RADIUS) AND frame = $counter;/g"

    sed -i "$(echo $QUERY_STRING)" ./test.sql
    ((counter++))
    psql -d $DATABASE_NAME -f ./test.sql >> postgresresfile 2>&1

    # retrieve mongo query
    mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb \
      | sed 1,4d \
      | sed 's/[^0-9]*//g' >> mongoresfile
  done
  ((repeater++))
done

echo "Done!";

#echo "Generating time measurement file (normal mongo) ..."
#mongo --eval "db.system.profile.find( { ns : 'mydb.$COLLECTION_NAME', ts : {\$gt: new ISODate('$START_TIME') }, op:'query' },{millis:1} ).forEach(function(f){print(tojson(f, '', true));});" mydb \
#  | sed 1,4d \
#  | sed 's/[^0-9]*//g' > mongoresfile
echo "Results (mongodb) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " mongoresfile
echo "Max 10 latencies:"
sort -n -r mongoresfile | head -10

sed -i '/DO/c\' postgresresfile
sed -i 's/psql:.\/test.sql:24: NOTICE://g' postgresresfile
sed -i 's/ //g' postgresresfile
echo "Done!";

echo "Results (postgresql) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " postgresresfile
echo "Max 3 latencies:"
sort -n -r postgresresfile | head -10
