#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=180
MAX_HEIGHT=90
MAX_FRAMES=101

# POSTGRES
TABLE_NAME=picture
DATABASE_NAME=gpstest

> mongo_rands_radial_center
> mongo_rands_radial_radius
> psql_rands_radial

echo "Executing random crop queries...";

repeater=0
max_repeats=100

while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    echo $(($repeater*$MAX_FRAMES + $counter));
    CENTER_LAT=$(( $RANDOM % $MAX_HEIGHT  ))
    CENTER_LON=$(( $RANDOM % $MAX_WIDTH ))
    NEG_LAT=$(( $RANDOM % 2 ))
    if [ $NEG_LAT -eq 0 ]
    then
      NEG_LAT="-"
    else
      NEG_LAT=""
    fi
    NEG_LON=$(( $RANDOM % 2 ))
    if [ $NEG_LON -eq 0 ]
    then
      NEG_LON="-"
    else
      NEG_LON=""
    fi
    RADIUS=$(( ($RANDOM * 1000) % 4000000 ))

    mongo_poly_center="[$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT]"
    mongo_poly_radius="$RADIUS"
    psql_poly="coord::geography,ST_SetSRID(ST_MakePoint($NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT),4326)::geography, $RADIUS"
    echo $mongo_poly_center >> mongo_rands_radial_center
    echo $mongo_poly_radius >> mongo_rands_radial_radius
    echo $psql_poly >> psql_rands_radial

    ((counter++))
  done
  ((repeater++))
  echo $repeater
done

echo "Done!";
