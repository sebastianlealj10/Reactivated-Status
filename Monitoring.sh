#!/bin/bash

set_proxy () {
  case $1 in
    USA)
      curl $2 -x, --proxy http://customer-analyst-cc-US:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Brazil)
      curl $2 -x, --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Chile)
      curl $2 -x, --proxy http://customer-analyst-cc-CL:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Mexico)
      curl $2 -x, --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Japan)
      curl $2 -x, --proxy http://customer-analyst-cc-JP:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Peru)
      curl $2 -x, --proxy http://customer-analyst-cc-PE:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Argentina)
      curl $2 -x, --proxy http://customer-analyst-cc-AR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    *)
      curl $2 > $3
      ;;
  esac
}

rm  ChangeStatus.csv
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
echo TicketID,Country,URL > tickets.csv
echo -e "localtest,Colombia,http://localhost/Phishingtest.html" >> tickets.csv

while read line
do
  ID=`echo $line | cut -d, -f1`
  COUNTRY=`echo $line | cut -d, -f2`
  URL=`echo $line | cut -d, -f3`
  if [ $ID != TicketID ]
    then
      if [ ! -f "HTMLS/$ID.html" ]
        then
            var="HTMLS/$ID.html"
            set_proxy $COUNTRY $URL $var
      fi
      oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
      set_proxy $COUNTRY $URL "newsite.html"
      newsite_len=$(cat newsite.html | wc -l)
      if [ $newsite_len -ge $oldsite_len ];
        then
          if [ $newsite_len != 0 ];
            then
              diff=$(sdiff -B -s newsite.html "HTMLS/$ID".html | wc -l)
              common=$(expr $newsite_len - $oldsite_len)
              percentage=$(echo "100 * $diff/ $newsite_len" | bc)
            else
              percentage=0
          fi
        else
            if [ $newsite_len != 0 ];
              then
                diff=$(sdiff -B -s "HTMLS/$ID".html  newsite.html | wc -l)
                common=$(expr $oldsite_len - $newsite_len)
                percentage=$(echo "100 * $diff/ $oldsite_len" | bc)
            else
              percentage=0
            fi
      fi
      echo 'Porcentaje de diferencia: ' $percentage
      if [[ $percentage -gt 40 ]];
        then
          echo "Reactivated"
          echo TicketID,Country,URL > ChangeStatus.csv
          echo -e $ID,$COUNTRY,$URL >> ChangeStatus.csv
      fi
  fi
done <tickets.csv
