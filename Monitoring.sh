#!/bin/bash

URL="http://goole.com"
#curl $URL -L --compressed -s -x --proxy http://customer-analyst-cc-JP:CTAC@cyxtera.com2018@pr.oxylabs.io:7777 > newsite.html

curl $URL -L --compressed -s -x --proxy http://customer-analyst-cc-JP:CTAC@cyxtera.com2018@pr.oxylabs.io:7777 > newsite.html
mv newsite.html oldsite.html 2> /dev/null
oldsite_len=$(cat oldsite.html | wc -l)
echo 'longitud del sitio original: '$oldsite_len
for (( ; ; ));
do
    curl $URL -L --compressed -s > newsite.html
    newsite_len=$(cat newsite.html | wc -l)
    if [ $newsite_len -gt 0 ]; then
      echo 'longitud del nuevo sitio: '$newsite_len
      diff=$(sdiff -B -s newsite.html oldsite.html | wc -l)
      echo 'Diferencia: ' $diff
      common=$(expr $newsite_len - $oldsite_len)
      echo 'cambio: '$common
      percentage=$(echo "100 * $diff/ $newsite_len" | bc)
    else
      percentage=0
    fi
    echo 'Porcentaje de diferencia: ' $percentage
    if [[ $percentage -gt 40 ]]; then
      echo 'Posible Reactivacion!!'
    fi
    sleep 10
done
