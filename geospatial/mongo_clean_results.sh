#!/bin/bash

#echo "Results (mongodb) : "
#python stddev.py ./mongo_box_results/mongoresfile
#echo "Max 10 latencies:"
#sort -n -r ./mongo_box_results/mongoresfile | head -10

echo "Results (near_1k) : "
python stddev.py ./mongo_results/near_1k
echo "Max 10 latencies:"
sort -n -r ./mongo_results/near_1k | head -10

echo "Results (nearSphere_1k) : "
python stddev.py ./mongo_results/nearSphere_1k
echo "Max 10 latencies:"
sort -n -r ./mongo_results/nearSphere_1k | head -10

echo "Results (geoWithin_1k) : "
python stddev.py ./mongo_results/geoWithin_1k
echo "Max 10 latencies:"
sort -n -r ./mongo_results/geoWithin_1k | head -10
