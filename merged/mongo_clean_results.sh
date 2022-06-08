#!/bin/bash

echo "Results (mongodb) : "
python stddev.py ./mongo_box_results/mongoresfile
echo "Max 10 latencies:"
sort -n -r ./mongo_box_results/mongoresfile | head -10
