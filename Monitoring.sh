#!/bin/bash
#.............................................Function to set the proper proxy, get the body and HTTP response form the URL
set_proxy () {
  case $1 in
    USA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-US:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    BRAZIL)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    CHILE)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-CL:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    MEXICO)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    JAPAN)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-JP:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    PERU)
      curl $2 -# -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-PE:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    ARGENTINA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-AR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    BOLIVIA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-BO:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    DOMINICANREPUBLIC)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n%{http_code}" --proxy http://customer-analyst-cc-DO:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    *)
      curl $2 -# -k -L -w,--progress-bar --insecure --write-out "\n%{http_code}"> $3
      ;;
  esac
}
#......................................................................

#...........................Create a new folder for save the HTMLS
rm  ChangeStatus.csv > /dev/null 2>&1
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
#..............................................Example of csv
#echo TicketID,Country,URL > tickets.csv
#echo -e "localtest1,USA,https://en.wikipedia.org" >> tickets.csv
#echo -e "localtest2,JAPAN,http://ht.ly/FftD30lbRu0" >> tickets.csv


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
                set_proxy $COUNTRY $URL $var
            fi
            if [ "$?" -ne 0 ]
              then
                rm "HTMLS/$ID.html"
            fi
      continue
      fi
#......................................
#.............................It allows compare the urls just if the html was loaded previusly
if [ -f "HTMLS/$ID.html" ]
    then
#..........................
#.....................extracts some data from the html
      respold=$( tail -n 1 "HTMLS/$ID".html)
      first_old="${respold:0:1}"
      oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
#..................Load the html by proxy
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
#....................extracts soeme data from the current html
      newsite_len=$(cat newsite.html | wc -l)
      respnew=$( tail -n 1 "HTMLS/$ID".html)
#................................................
#...........................conditions for a Reactivated
      if [ $newsite_len -ge $oldsite_len ];
        then
          if [ $newsite_len != 0 ];
            then
              diff=$(sdiff -B -s newsite.html "HTMLS/$ID".html | wc -l)
              percentage=$(echo "100 * $diff/ $newsite_len" | bc)
            else
              percentage=0
        fi
        else
        if [ $newsite_len != 0 ];
          then
            diff=$(sdiff -B -s "HTMLS/$ID".html  newsite.html | wc -l)
            percentage=$(echo "100 * $diff/ $oldsite_len" | bc)
          else
            percentage=0
       fi
    fi
    first_new="${respnew:0:1}"
    if [[ $percentage -gt 60 ]];
      then
        if [[ $first_new == 2 ]];
          then
            echo "Reactivated"
            echo TicketID,Country,URL > ChangeStatus.csv
            echo -e $ID,$COUNTRY,$URL >> ChangeStatus.csv
        fi
    fi
#..............................................................................
  fi
fi
done <tickets.csv
