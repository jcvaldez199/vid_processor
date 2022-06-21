#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=180
MAX_HEIGHT=90
MAX_FRAMES=101

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongo_rands_box
> psql_rands_box

echo "Executing random crop queries...";

repeater=0
max_repeats=100

while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));

    mongo_poly="[$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT]"
    psql_poly=$(python3 generate_gps_box.py psql)
    echo $psql_poly
    
    exit 1;
    echo $mongo_poly >> mongo_rands_box
    echo $psql_poly >> psql_rands_box

    ((counter++))
  done
  ((repeater++))
  echo $repeater
done

echo "Done!";
