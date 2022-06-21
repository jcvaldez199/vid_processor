#!/bin/bash

echo "Results (psql) : "
python stddev.py ./postgres_results/st_dwithin_1k
echo "Max 10 latencies:"
sort -n -r ./postgres_results/st_dwithin_1k | head -10
