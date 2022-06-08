#!/bin/bash

#constants
BASE_FRAME=5
MAX_WIDTH=640
MAX_HEIGHT=354
MAX_FRAMES=101

# POSTGRES
DATABASE_NAME=gpstest

> postgres_results/st_within
> postgres_results/st_contains
> postgres_results/st_contains_properly
> postgres_results/st_covers
> postgres_results/st_covered_by

echo "Executing random crop queries...";

repeater=0
max_repeats=10
MAX_FRAMES=101

# activate timing
#psql -d gpstest -c '\timing';
while [ $repeater -lt $max_repeats ]
do
  counter=1
  while [ $counter -lt $MAX_FRAMES ]
  do
    line_num=$(($repeater*$MAX_FRAMES + $counter));
    echo $line_num
    polygon=$(sed "$line_num q;d" psql_rands_2d;)

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_Within(coord, $polygon) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_within 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_Contains($polygon, coord) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_contains 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_ContainsProperly($polygon, coord) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_contains_properly 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_Covers($polygon, coord) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_covers 2>&1

    QUERY_STRING="18s/.*/PERFORM grayscale FROM picture WHERE ST_CoveredBy(coord, $polygon) AND frame = $counter;/g"
    sed -i "$(echo $QUERY_STRING)" ./test.sql
    psql -d $DATABASE_NAME -f ./test.sql >> ./postgres_results/st_covered_by 2>&1

    ((counter++))
  done
  ((repeater++))
done

echo "Done!";
exit 1;

sed -i '/DO/c\' postgresresfile
sed -i 's/psql:.\/test.sql:24: NOTICE://g' postgresresfile
sed -i 's/ //g' postgresresfile
echo "Done!";

echo "Results (postgresql) : "
awk '{s+=$1}END{print "ave:",(NR?s/NR:"NaN")}' RS=" " postgresresfile
echo "Max 3 latencies:"
sort -n -r postgresresfile | head -10
