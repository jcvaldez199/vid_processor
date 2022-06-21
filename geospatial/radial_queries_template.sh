#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
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
#psql -d gpstest -c '\timing';
while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    line_num=$(($repeater*$MAX_FRAMES + $counter));
    echo $line_num
    polygon=$(sed "$line_num q;d" psql_rands_radial;)

    #echo "ST_DFullyWithin : "
    #psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_DFullyWithin($polygon) AND frame = $counter;";

    #echo "ST_DWithin : "
    #psql -d gpstest -c "SELECT COUNT(*) FROM picture WHERE ST_DWithin($polygon) AND frame = $counter;";

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_DWithin($polygon) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_dwithin 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_DFullyWithin($polygon) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_dfully_within 2>&1

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";

sed -i '/DO/c\' ./postgres_results/st_dwithin
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_dwithin
sed -i 's/ //g' ./postgres_results/st_dwithin
echo "Done!";
echo "Results (st_dwithin) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " ./postgres_results/st_dwithin
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_dwithin | head -10

sed -i '/DO/c\' ./postgres_results/st_dfully_within
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_dfully_within
sed -i 's/ //g' ./postgres_results/st_dfully_within
echo "Done!";
echo "Results (st_dfully_within) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " ./postgres_results/st_dfully_within
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_dfully_within | head -10
