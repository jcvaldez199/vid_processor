#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongoresfile
> postgresresfile

echo "Executing random crop queries...";

repeater=0
max_repeats=1
MAX_FRAMES=2

while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));
    BOTTOM_X=$(( $RANDOM % $MAX_WIDTH  ))
    BOTTOM_Y=$(( $RANDOM % $MAX_HEIGHT ))
    TOP_X=$(( $BOTTOM_X + $RANDOM % ($MAX_WIDTH - $BOTTOM_X) ))
    TOP_Y=$(( $BOTTOM_Y + $RANDOM % ($MAX_HEIGHT - $BOTTOM_Y) ))

    #QUERY_STRING="18s/.*/PERFORM grayscale FROM $TABLE_NAME WHERE ST_Within(coord, ST_GeomFromText('POLYGON(($BOTTOM_X $BOTTOM_Y, $BOTTOM_X $TOP_Y, $TOP_X $TOP_Y, $TOP_X $BOTTOM_Y, $BOTTOM_X $BOTTOM_Y))')) AND frame = $counter;/g"

    # confirm the geometry to be used for the query
    polygon="ST_GeomFromText('POLYGON(($BOTTOM_X $BOTTOM_Y, $BOTTOM_X $TOP_Y, $TOP_X $TOP_Y, $TOP_X $BOTTOM_Y, $BOTTOM_X $BOTTOM_Y))')"

    echo "ST_WITHIN : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_Within(coord, $polygon) AND frame = $counter;";

    echo "ST_Contains : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_Contains($polygon, coord) AND frame = $counter;";

    echo "ST_ContainsProperly : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_ContainsProperly($polygon, coord) AND frame = $counter;";

    echo "ST_Covers : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_Covers($polygon, coord) AND frame = $counter;";

    echo "ST_CoveredBy : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_CoveredBy(coord, $polygon) AND frame = $counter;";

    echo "ST_DFullyWithin : "
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_Contains($polygon, coord) AND frame = $counter;";

    #sed -i "$(echo $QUERY_STRING)" ./test.sql
    ((counter++))
    #psql -d $DATABASE_NAME -f ./test.sql >> postgresresfile 2>&1

  done
  ((repeater++))
  echo $repeater
done

echo "Done!";
