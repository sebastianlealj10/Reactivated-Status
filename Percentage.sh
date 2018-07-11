#!/bin/bash

    A_len=$(cat new.html | wc -l)
    echo 'longitud del nuevo sitio: '$A_len
    B_len=$(cat old.html | wc -l)
    echo 'longitud del sitio original: '$B_len
    diff=$(sdiff -B -s new.html old.html | wc -l)
    echo 'Diferencia: ' $diff
    common=$(expr $A_len - $B_len)
    echo 'resta: ' $diff
    percentage=$(echo "100 * $diff/ $A_len" | bc)
    echo 'Porcentaje de diferencia: ' $percentage
