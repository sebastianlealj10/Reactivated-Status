#!/bin/bash

    A_len=$(cat new.html | wc -l)
    echo $A_len
    B_len=$(cat old.html | wc -l)
    echo $B_len 
    diff=$(sdiff -B -s new.html old.html | wc -l)
    echo $diff
    common=$(expr $A_len - $diff)
    echo $common
    percentage=$(echo "100 * $common / $B_len" | bc)
    echo $percentage
    sleep 10

