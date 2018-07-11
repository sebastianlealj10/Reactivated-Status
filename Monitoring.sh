#!/bin/bash

URL="http://localhost/Phishingtest.html"
curl $URL -L --compressed -s > new.html
mv new.html old.html 2> /dev/null
B_len=$(cat old.html | wc -l)
echo 'longitud del sitio original: '$B_len
for (( ; ; ));
do
    curl $URL -L --compressed -s > new.html
    A_len=$(cat new.html | wc -l)
    if [ $A_len -gt 0 ]; then
      echo 'longitud del nuevo sitio: '$A_len
      diff=$(sdiff -B -s new.html old.html | wc -l)
      echo 'Diferencia: ' $diff
      common=$(expr $A_len - $B_len)
      echo 'cambio: '$common
      percentage=$(echo "100 * $diff/ $A_len" | bc)
    else
      percentage=0
    fi
    echo 'Porcentaje de diferencia: ' $percentage
    if [[ $percentage -gt 40 ]]; then
      echo 'Posible Reactivacion!!'
    fi
    sleep 10
done
