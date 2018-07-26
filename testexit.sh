#!/bin/bash

curl https://mufg-jpn-auth-ssl.thechuckoliverteam.com/index_pc.php -s -S -x, --silent --show-error --proxy http://customer-analyst-cc-AR:CTAC%40cyxtera.com2018@pr.oxylabs.io:7777> test.html

if [ "$?" -eq 0 ]
then
  echo "all good"
else
  echo "error"
fi
echo $?
