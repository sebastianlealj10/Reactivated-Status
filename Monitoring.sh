#!/bin/bash
#.............................................Function to set the proper proxy, get the body, redirect and response form the URL
set_proxy () {
  case $1 in
    USA)
      curl $2 -k -L -w -x,--insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-US:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Brazil)
      curl $2 -k -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Chile)
      curl $2 -k -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-CL:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Mexico)
      curl $2 -k -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Japan)
      curl $2 -k -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-JP:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Peru)
      curl $2  -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-PE:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    Argentina)
      curl $2 -k -L -w -x, --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-AR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    *)
      curl $2 -k -L -w, --write-out "\n%{http_code}"> $3
      ;;
  esac
}
#......................................................................

#...........................Create a new folder for save the HTMLS
rm  ChangeStatus.csv
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
#...............................................
echo TicketID,Country,URL > tickets.csv
echo -e "localtest1,Colombia,http://localhost" >> tickets.csv
echo -e "test2,Colombia,https://stackoverflow.com/" >> tickets.csv
echo -e "localtest2,Colombia,http://localhost" >> tickets.csv
#echo -e "test1,Japan,https://mufg-jpn-auth-ssl.thechuckoliverteam.com/index_pc.php" >> tickets.csv
#echo -e "test2,USA,http://t-arax.com/mediia/Beth/online/login.php?cmd=login_submit&id=MTA2NTQwODA3Nw==MTA2NTQwODA3Nw==&session=MTA2NTQwODA3Nw==MTA2NTQwODA3Nw==" >> tickets.csv
#echo -e "test3,Brazil,https://truedie.com/stat/atualizar-cadastro/html/classic/" >> tickets.csv
#echo -e "test4,Brazil,https://www59.saldaodospais.com.br/produto/133453169/smartphone-motorola-moto-g6-play-dual-chip-android-oreo-8-0-tela-5-7-octa-core-1-4-ghz-32gb-4g-camera-13mp-indigo/carrinho/" >> tickets.csv
echo -e "test5,Chile,http://racoesfutura.com.br/wp-includes/www.itau.cl/" >> tickets.csv
#echo -e "localtest1,Colombia,http://localhost/Phishingtest.html" >> tickets.csv
echo -e "test6,Chile,http://finmedbrokers.co.za/Inverter/MicroEmpresas/imagenes/comun2008/nuevo_paglg_pers2.html" >> tickets.csv
#echo -e "test7,US,http://apktrending.com/apk-android/app-columbiabank3685-mobile-production.html" >> tickets.csv
echo -e "test8,US,http://appnaz.com/es-cl/android/clc-m%C3%B3vil-es.ingenia.clc.app.produccion" >> tickets.csv
#echo -e "test9,Brazil,http://apktrending.com/apk-android/app-m4u-cielomobile.html" >> tickets.csv

#..............................This loop is used for read the tickets csv file
while read line
do
#....................................
#.......................Extracts the fields for each ticket
  ID=`echo $line | cut -d, -f1`
  COUNTRY=`echo $line | cut -d, -f2`
  URL=`echo $line | cut -d, -f3`
#......................................
#.......... Verfies if the html for this ticket already exists, if it is not, creates a new html
  if [ $ID != TicketID ]
    then
      if [ ! -f "HTMLS/$ID.html" ]
        then
            var="HTMLS/$ID.html"
            set_proxy $COUNTRY $URL $var
            if [ "$?" -ne 0 ]
              then
                set_proxy $COUNTRY $URL $var
            fi
            if [ "$?" -ne 0 ]
              then
                rm "HTMLS/$ID.html"
            fi
      continue
      fi
  fi
#......................................
#.............................It allows compare the urls just if the html was loaded previusly
if [ -f "HTMLS/$ID.html" ]
    then
#..........................
#.....................extracts soeme dates from the html
      respold=$( tail -n 1 "HTMLS/$ID".html)
      echo $respold
      first_old="${respold:0:1}"
      echo $first_old
      oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
#..................Load the html through proxy and try several times a sucesfull request...Yes Oxylabs is not the best
      set_proxy $COUNTRY $URL "newsite.html"
      if [ "$?" -ne 0 ]
        then
          set_proxy $COUNTRY $URL "newsite.html"
      fi
      if [ "$?" -ne 0 ]
        then
          cat HTMLS/$ID.html > "newsite.html"
      fi
#..............................................
#....................extracts soeme dates from the current html
      newsite_len=$(cat newsite.html | wc -l)
      respnew=$( tail -n 1 "HTMLS/$ID".html)
#................................................
#...........................conditions for a Reactivated
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
    first_new="${respnew:0:1}"
    if [ $percentage -gt 40 -a $first_new == 2 ];
      then
        echo "Reactivated"
        echo TicketID,Country,URL > ChangeStatus.csv
        echo -e $ID,$COUNTRY,$URL >> ChangeStatus.csv
    fi
    if [[ $respold -eq 404 && $first_new -eq 2 ]];
      then
        echo "Reactivated"
        echo TicketID,Country,URL > ChangeStatus.csv
        echo -e $ID,$COUNTRY,$URL >> ChangeStatus.csv
      fi
    if [[ $respold -eq 403 && $first_new -eq 2 ]];
      then
        echo "Reactivated"
        echo TicketID,Country,URL > ChangeStatus.csv
        echo -e $ID,$COUNTRY,$URL >> ChangeStatus.csv
#..............................................................................
    fi
  fi
done <tickets.csv
