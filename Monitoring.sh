#!/bin/bash
#.............................................Function to set the proper proxy, get the body and HTTP response form the URL
set_proxy () {
  case $1 in
    USA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-US:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    BRAZIL)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-BR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    CHILE)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-CL:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    MEXICO)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    JAPAN)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-JP:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    PERU)
      curl $2 -# -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-PE:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    ARGENTINA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-AR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    BOLIVIA)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-BO:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    DOMINICANREPUBLIC)
      curl $2 -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]" \
      --proxy http://customer-analyst-cc-DO:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> $3
      ;;
    *)
      curl $2 -# -k -L -w,--progress-bar --insecure --write-out "\n[%{http_code}]"> $3
      ;;
  esac
}
#......................................................................+
#curl https://google.com -# -k -L -w -x,--progress-bar --insecure --write-out "\n[%{http_code}]\n[%{remote_ip}]" --proxy http://customer-analyst-cc-MX:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> test.html

#...........................Create a new folder for save the HTMLS
rm  ChangeStatus.csv > /dev/null 2>&1
echo TicketID,Country,URL,Percentage > ChangeStatus.csv
if [ ! -d HTMLS ]
then
    mkdir -p HTMLS
fi
#..............................................Example of csv
echo TicketID,Country,URL > tickets.csv
echo -e "test2,JAPAN,http://www.mufg-jp.biz/inet/life/ninsyou/entry/top" >> tickets.csv
echo -e "test3,COLOMBIA,https://serverfault.com" >> tickets.csv

#..............................This loop is used for read the tickets csv file  curl -L https://stackoverflow.com | grep '<title>'

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
            resp_old=$( tail -1 "HTMLS/$ID".html | sed 's/.$//' | sed 's/^.//' )
            echo $?
            if [ "$?" -ne 0 ] || [ "$resp_old" -eq 000 ]
              then
                set_proxy $COUNTRY $URL $var
                resp_old=$( tail -1 "HTMLS/$ID".html | sed 's/.$//' | sed 's/^.//' )
                if [ "$?" -ne 0 ] || [ "$resp_old" -eq 000 ]
                  then
                    set_proxy $COUNTRY $URL $var
                    resp_old=$( tail -1 "HTMLS/$ID".html | sed 's/.$//' | sed 's/^.//' )
                    if [ "$?" -ne 0 ] || [ "$resp_old" -eq 000 ]
                      then
                        rm "HTMLS/$ID.html"
                    fi
                  else
                    ip_old=$(dig +short $(echo $URL | awk -F[/:] '{print $4}')| head -1)
                    title_old=$(cat "HTMLS/$ID".html  | grep '<title>' | sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip;T;q')
                    echo $ip_old
                    echo $title_old
                    echo -e "\n[$ip_old]" >> "HTMLS/$ID".html
                    echo -e "[$title_old]" >> "HTMLS/$ID".html
                fi
              else
                ip_old=$(dig +short $(echo $URL | awk -F[/:] '{print $4}')| head -1)
                title_old=$(cat "HTMLS/$ID".html  | grep '<title>' | sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip;T;q')
                echo $ip_old
                echo $title_old
                echo -e "\n[$ip_old]" >> "HTMLS/$ID".html
                echo -e "[$title_old]" >> "HTMLS/$ID".html
            fi
      continue
      fi
#......................................
#.............................It allows compare the urls just if the html was loaded previusly
if [ -f "HTMLS/$ID.html" ]
    then
#..........................
#.....................extracts some data from the html
      resp_old=$( tail -3 "HTMLS/$ID".html | head -1 | sed 's/.$//' | sed 's/^.//' )
      ip_old=$( tail -2 "HTMLS/$ID".html | head -1 | sed 's/.$//' | sed 's/^.//' )
      title_old=$( tail -1 "HTMLS/$ID".html | sed 's/.$//' | sed 's/^.//' )
      echo "resp old: "$resp_old
      echo "ip old: "$ip_old
      echo "title old: "$title_old
      first_old="${resp_old:0:1}"
      oldsite_len=$(cat "HTMLS/$ID".html | wc -l)
#..................Load the html by proxy
      set_proxy $COUNTRY $URL "newsite.html"
      resp_new=$( tail -1 newsite.html | sed 's/.$//' | sed 's/^.//' )
      if [ "$?" -ne 0 ] || [ "$resp_new" -eq 000 ]
        then
          set_proxy $COUNTRY $URL "newsite.html"
          resp_new=$( tail -1 newsite.html | sed 's/.$//' | sed 's/^.//' )
      fi
      if [ "$?" -ne 0 ] || [ "$resp_new" -eq 000 ]
        then
          set_proxy $COUNTRY $URL "newsite.html"
          resp_new=$( tail -1 newsite.html | sed 's/.$//' | sed 's/^.//' )
      fi
      if [ "$?" -ne 0 ] || [ "$resp_new" -eq 000 ]
        then
         cat HTMLS/$ID.html > "newsite.html"
      fi
#..............................................
#....................extracts some data from the current html
      newsite_len=$(cat newsite.html | wc -l)
      resp_new=$( tail -1 newsite.html | sed 's/.$//' | sed 's/^.//' )
      ip_new=$(dig +short $(echo $URL | awk -F[/:] '{print $4}')| head -1)
      title_new=$(cat newsite.html | grep '<title>' | sed -n 's/.*<title>\(.*\)<\/title>.*/\1/ip;T;q')
      echo "resp new: "$resp_new
      echo "ip new: "$ip_new
      echo "title: "$title_new
#................................................
#...........................conditions for a Reactivated
echo "new len: "$newsite_len


    diff=$(($(sdiff -B -s -I, --ignore-matching-lines=[...] newsite.html "HTMLS/$ID".html | wc -l) - 3))
    echo "diff: "$diff
    percentage=$(echo "100 * $diff/ $newsite_len" | bc)
    first_new="${respnew:0:1}"
    echo "Percentage: " $percentage
    if [[ $percentage -gt 60 ]]
      then
        HTML_Code=25
      else
        HTML_Code=0
    fi
    if [ "$resp_old" -ne "$resp_new" ]
      then
        echo "resp:si"
        HTML_Resp=25
      else
        HTML_Resp=0
    fi
    if [ "$ip_old" != "$ip_new" ] && [ ! -z "$ip_new" ]
      then
        echo "ip:si"
        ip=25
      else
        ip=0
    fi
    if [ "$title_old" != "$title_new" ] && [ ! -z "$title_new" ]
      then
        echo "title:si"
        title=25
      else
        title=0
    fi
    sum=$((HTML_Code + HTML_Resp + ip + title))
    echo "add" $sum
    if [[ $sum -gt 25 ]]
      then
        echo -e $ID,$COUNTRY,$URL,$sum >> ChangeStatus.csv
    fi
#..............................................................................
  fi
fi
done <tickets.csv


