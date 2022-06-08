#!/bin/bash

echo "st_within"
sed -i '/DO/c\' ./postgres_results/st_within
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_within
sed -i 's/ //g' ./postgres_results/st_within
python stddev.py ./postgres_results/st_within
echo "Results (./postgres_results/st_within) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_within | head -10

echo "st_contains"
sed -i '/DO/c\' ./postgres_results/st_contains
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_contains
sed -i 's/ //g' ./postgres_results/st_contains
python stddev.py ./postgres_results/st_contains
echo "Results (./postgres_results/st_contains) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_contains | head -10

echo "st_contains_properly"
sed -i '/DO/c\' ./postgres_results/st_contains_properly
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_contains_properly
sed -i 's/ //g' ./postgres_results/st_contains_properly
python stddev.py ./postgres_results/st_contains_properly
echo "Results (./postgres_results/st_contains_properly) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_contains_properly | head -10

echo "st_covers"
sed -i '/DO/c\' ./postgres_results/st_covers
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_covers
sed -i 's/ //g' ./postgres_results/st_covers
python stddev.py ./postgres_results/st_covers
echo "Results (./postgres_results/st_covers) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_covers | head -10

echo "st_covered_by"
sed -i '/DO/c\' ./postgres_results/st_covered_by
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_covered_by
sed -i 's/ //g' ./postgres_results/st_covered_by
python stddev.py ./postgres_results/st_covered_by
echo "Results (./postgres_results/st_covered_by) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_covered_by | head -10

echo "st_dwithin"
sed -i '/DO/c\' ./postgres_results/st_dwithin
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_dwithin
sed -i 's/ //g' ./postgres_results/st_dwithin
python stddev.py ./postgres_results/st_dwithin
echo "Results (./postgres_results/st_dwithin) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_dwithin | head -10

echo "st_dfully_within"
sed -i '/DO/c\' ./postgres_results/st_dfully_within
sed -i 's/psql:.\/test.sql:24: NOTICE://g' ./postgres_results/st_dfully_within
sed -i 's/ //g' ./postgres_results/st_dfully_within
python stddev.py ./postgres_results/st_dfully_within
echo "Results (./postgres_results/st_dfully_within) : "
echo "Max 3 latencies:"
sort -n -r ./postgres_results/st_dfully_within | head -10
