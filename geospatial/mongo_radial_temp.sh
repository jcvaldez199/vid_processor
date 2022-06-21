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
MAX_FRAMES=10

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

    echo "nearSphere : "
    mongo --eval "db.imagetest_normal.count({ loc : { \$nearSphere : { \$geometry : { type:\"Point\", coordinates : [$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT] }, \$maxDistance : $RADIUS } }, frame:$counter });" mydb

    echo "near : "
    mongo --eval "db.imagetest_normal.count({ loc : { \$near : { \$geometry : { type:\"Point\", coordinates : [$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT] }, \$maxDistance : $RADIUS } }, frame:$counter });" mydb

    echo "getWithin : "
    mongo --eval "db.imagetest_normal.count({ loc : { \$geoWithin : {\$centerSphere:[[$NEG_LON$CENTER_LON,$NEG_LAT$CENTER_LAT],$RADIUS/6378000]} }, frame:$counter });" mydb

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

