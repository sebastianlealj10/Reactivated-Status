#!/bin/bash

set_proxy () {
  case $1 in
    USA)
      curl $2 -x, --proxy http://customer-analyst-cc-US:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      echo "USA"
      ;;
    Brazil)
      curl $2 -x, --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      echo "Brasil"
      ;;
    Chile)
      curl $2 -L --compressed -s -x, --proxy http://customer-analyst-cc-CL:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Mexico)
      curl $2 -L --compressed -s -x, --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Japan)
      curl $2 -L --compressed -s -x, --proxy http://customer-analyst-cc-JP:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    *)
      curl $2 > $3
      ;;
esac
}

rm Reactivated.csv
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
echo TicketID,Country,URL > tickets.csv
echo -e "easy1,USA,https://www.computerhope.com" >> tickets.csv
echo -e "easy2,COLOMBIA,https://stackoverflow.com" >> tickets.csv
echo -e "test,Brazil,http://americanas.revolucaolanches.com.br/j7_americanas/home.php?170239.189.6.21.225.80728161847219/" >> tickets.csv
echo -e "testjapanproxy,Japan,https://mufg-ufj-nicos-group.charlesoliverblog.com/index_pc.php" >> tickets.csv
echo -e "localtest,Colombia,http://localhost/Phishingtest.html" >> tickets.csv
echo -e "testjapanproxy2,Japan,https://mitsubishi-ufj-financial.findmyincomegap.com/index_pc.php" >> tickets.csv

while read line
do
  ID=`echo $line | cut -d, -f1`
  COUNTRY=`echo $line | cut -d, -f2`
  URL=`echo $line | cut -d, -f3`
  if [ $ID != TicketID ]
    then
      echo $ID
      if [ ! -f "HTMLS/$ID.html" ]
        then
            var="HTMLS/$ID.html"
            set_proxy $COUNTRY $URL $var
      fi
      oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
      echo 'longitud del sitio original: '$oldsite_len
      set_proxy $COUNTRY $URL "newsite.html"
      newsite_len=$(cat newsite.html | wc -l)
      if [ $newsite_len -gt 0 ];
        then
          echo 'longitud del nuevo sitio: '$newsite_len
          diff=$(sdiff -B -s newsite.html "HTMLS/$ID".html | wc -l)
          echo 'Diferencia: ' $diff
          common=$(expr $newsite_len - $oldsite_len)
          echo 'cambio: '$common
          percentage=$(echo "100 * $diff/ $newsite_len" | bc)
      else
        percentage=0
      fi
      echo 'Porcentaje de diferencia: ' $percentage
      if [[ $percentage -gt 40 ]];
        then
          echo "Reactivated"
          echo TicketID,Country,URL > Reactivated.csv
          echo -e $ID,$COUNTRY,$URL >> Reactivated.csv
      fi
  fi
done <tickets.csv
#  curl http://americanas.revolucaolanches.com.br/j7_americanas/home.php?170239.189.6.21.225.80728161847219/ -x, --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> proxytest.html

#curl -x http://pr.oxylabs.io:7777 -- customer-analyst-cc-BR: CTAC@cyxtera.com2018 -L http://google.com
