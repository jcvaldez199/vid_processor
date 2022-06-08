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

> mongo_rands_radial_center
> mongo_rands_radial_radius
> psql_rands_radial

echo "Executing random crop queries...";

repeater=0
max_repeat=100
MAX_FRAMES=101
while [ $repeater -lt $max_repeat ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));
    CENTER_X=$(( $RANDOM % $MAX_WIDTH  ))
    CENTER_Y=$(( $RANDOM % $MAX_HEIGHT ))
    RADIUS=$(( $RANDOM % (($MAX_WIDTH>$MAX_HEIGHT ? $MAX_HEIGHT : $MAX_WIDTH)/ 2)))



    mong_cent="[$CENTER_X,$CENTER_Y]"
    mong_rad="$RADIUS"
    post="coord, ST_GeomFromText('POINT($CENTER_X $CENTER_Y)'), $RADIUS"
    echo $mong_cent >> mongo_rands_radial_center
    echo $mong_rad >> mongo_rands_radial_radius
    echo $post >> psql_rands_radial
    #polygon="coord, ST_GeomFromText('POINT($CENTER_X $CENTER_Y)'), $RADIUS"

    #QUERY_STRING="18s/.*/PERFORM grayscale FROM $TABLE_NAME WHERE ST_DFullyWithin(coord, ST_GeomFromText('POINT($CENTER_X $CENTER_Y)'), $RADIUS) AND frame = $counter;/g"

    #echo "ST_DFullyWithin : "
    #psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_DFullyWithin($polygon) AND frame = $counter;";

    #echo "ST_DWithin : "
    #psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_DWithin($polygon) AND frame = $counter;";

    ((counter++))

  done
  ((repeater++))
done

echo "Done!";
