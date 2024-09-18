#!/bin/bash
N=10
CURRENT_SUM=0
for((i=0; i<=N; i++)); do 
    CURRENT_SUM=$((CURRENT_SUM+i))
done
echo "TOTAL SUM: $CURRENT_SUM"