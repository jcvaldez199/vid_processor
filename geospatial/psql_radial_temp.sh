#!/bin/bash

#constants
MAX_WIDTH=180
MAX_HEIGHT=90
MAX_FRAMES=101

# POSTGRES
DATABASE_NAME=gpstest

> postgres_results/st_dwithin
> postgres_results/st_dfully_within

echo "Executing random crop queries...";

repeater=0
max_repeats=1
MAX_FRAMES=2

# activate timing
while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do

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
    echo $CENTER_LAT $CENTER_LON $RADIUS

    echo "ST_DWithin : "
    polygon="coord::geography,ST_SetSRID(ST_MakePoint($NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT),4326)::geography, $RADIUS"
    psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_DFullyWithin($polygon) AND frame = $counter;";

    mongo --eval "db.imagetest_normal.count({ loc : { \$nearSphere : { \$geometry : { type:\"Point\", coordinates : [$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT] }, \$maxDistance : $RADIUS } }, frame:$counter });" mydb

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

