#!/bin/bash
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
#echo TicketID,Country,URL > tickets.csv
echo -e "easy1,USA,https://www.computerhope.com" >> tickets.csv
echo -e "easy2,COLOMBIA,https://stackoverflow.com" >> tickets.csv
echo -e "test,USA,https://floorzrus.co.uk/wwpp22/XN6LfHeToV/Rz8YhhfiRXg/UB2AsaVrWh4/xkLaFTECeYf/XDhk4jf3oD/uf5rv5Prz6/7z9Wz6zzSz/QDR6HLgheGj/login.php?cmd=login_submit&id=599504f2d13f4e2be4ae797cf6ac4d09599504f2d13f4e2be4ae797cf6ac4d09&session=599504f2d13f4e2be4ae797cf6ac4d09599504f2d13f4e2be4ae797cf6ac4d09" >> tickets.csv
echo -e "localtest1,COLOMBIA,http://localhost/Phishingtest.html" >> tickets.csv
while read line
do
  ID=`echo $line | cut -d, -f1`
  COUNTRY=`echo $line | cut -d, -f2`
  URL=`echo $line | cut -d, -f3`
  echo $ID
  if [ ! -f "HTMLS/$ID.html" ]
    then
      echo "entrando"
      curl $URL -L --compressed -s > "HTMLS/$ID".html
  fi
  oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
  echo 'longitud del sitio original: '$oldsite_len
  curl $URL -L --compressed -s > newsite.html
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
done < tickets.csv
