#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongo_rands
> psql_rands

echo "Executing random crop queries...";

repeater=0
max_repeats=100

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

    mongo_poly="box:[[$BOTTOM_X,$BOTTOM_Y],[$TOP_X,$TOP_Y]]"
    psql_poly="ST_GeomFromText('POLYGON(($BOTTOM_X $BOTTOM_Y, $BOTTOM_X $TOP_Y, $TOP_X $TOP_Y, $TOP_X $BOTTOM_Y, $BOTTOM_X $BOTTOM_Y))')"
    echo $mongo_poly >> mongo_rands
    echo $psql_poly >> psql_rands

    ((counter++))
  done
  ((repeater++))
  echo $repeater
done

echo "Done!";
