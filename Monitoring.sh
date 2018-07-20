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
#echo -e "localtest,Colombia,http://localhost/Phishingtest.html" >> tickets.csv
echo -e "test,Brazil,https://www93.osmaisdesejadosdacategoria.com/tkn870029/smartphone-samsung-galaxy-s8-dual-chip-android-7-0-tela-5-8-octa-core-2-3ghz-64gb-4g-camera-12mp-preto/132118431/pr" >> tickets.csv
echo -e "test2,Mexico,https://noticiasadicionaisbrlltda.com/web/desktop/home.php?cli=&/rM2SrorGcM/1c2Ej9WdaZ.php" >> tickets.csv
echo -e "test3,Brazil,http://fanismastrokostas.gr/management/www.banco.bradesco/html/classic/shtm/" >> tickets.csv
echo -e "test4,Brazil,https://cef.gov-br.app/" >> tickets.csv
echo -e "test5,Japan,https://mufg-ufj-nicos-group.charlesoliverblog.com/index_pc.php" >> tickets.csv
echo -e "test6,Colombia,https://www.androidapkdescargar.com/banbif-app/pe.com.banBifBanking.icBanking.androidUI/" >> tickets.csv
echo -e "test7,Brazil,http://www.qbaili.com/js/?cliente=leonir-melo@uol.com.br" >> tickets.csv
echo -e "test8,Ecuador,http://solomax.com.tw/Uploads/Bete/" >> tickets.csv

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
      if [ $newsite_len -ge $oldsite_len ];
        then
          echo 'longitud del nuevo sitio: '$newsite_len
          if [ $newsite_len != 0 ];
            then
              diff=$(sdiff -B -s newsite.html "HTMLS/$ID".html | wc -l)
              echo 'Diferencia: ' $diff
              common=$(expr $newsite_len - $oldsite_len)
              echo 'cambio: '$common
              percentage=$(echo "100 * $diff/ $newsite_len" | bc)
            else
              percentage=0
          fi
        else
          echo 'longitud del nuevo sitio: '$newsite_len
            if [ $newsite_len != 0 ];
              then
                diff=$(sdiff -B -s "HTMLS/$ID".html  newsite.html | wc -l)
                echo 'Diferencia: ' $diff
                common=$(expr $oldsite_len - $newsite_len)
                echo 'cambio: '$common
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
#  curl https://www35.osmaisdesejadosdacategoria.com/tkn3885063/smartphone-samsung-galaxy-s8-dual-chip-android-7-0-tela-5-8-octa-core-2-3ghz-64gb-4g-camera-12mp-preto/132118431/pr -x, --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> proxytest.html

#curl -x http://pr.oxylabs.io:7777 -- customer-analyst-cc-BR: CTAC@cyxtera.com2018 -L http://google.com
