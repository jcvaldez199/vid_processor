#!/bin/bash

#echo "Results (mongodb) : "
#python stddev.py ./mongo_box_results/mongoresfile
#echo "Max 10 latencies:"
#sort -n -r ./mongo_box_results/mongoresfile | head -10

echo "Results (near) : "
python stddev.py ./mongo_results/near
echo "Max 10 latencies:"
sort -n -r ./mongo_results/near | head -10

echo "Results (getwithin) : "
python stddev.py ./mongo_results/geoWithin
echo "Max 10 latencies:"
sort -n -r ./mongo_results/geoWithin | head -10
