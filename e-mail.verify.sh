#!/bin/bash

#cd /home/xml/VerifyEmail

>dump.aux

while read line
do
        id=`echo $line | cut -d, -f2`
        if `grep -qw $id ../urls.list`
        then
                echo $line >> dump.aux
        fi
done < dump

cat dump.aux > dump

rm -f dump.aux

#Check file sent as argument

#if [ ! $# == 1 ]
#then
#	echo "Usage: $0 Filename"
#	exit 0
#fi

#Get MX for each domains

C_R="\e[01;31m" 			## Colors
C_B="\e[01;30m"
C_G="\e[01;32m"
C_END="\e[00m"

mxdomain_old="none"
SMTPSERV="none"

RM_FILE="validemails.csv"
RM_FILE1="invalidemails.csv"

rm -rf $RM_FILE $RM_FILE1

echo Email,TicketID > invalidemails.csv
echo Email,TicketID > validemails.csv

cat dump | while read LINE; do
{

    echo $LINE

mxdomain=`echo $LINE | cut -d "," -f1 | cut -d "@" -f2`
mxmail=`echo $LINE | cut -d "," -f1`

if [ "$mxdomain_old" != "$mxdomain" ]
then
    SMTPSERV=`host -t mx $mxdomain | cut -d " " -f 7 | sed 's/\.$//' | head -1`
    ping -c1 $SMTPSERV >/dev/null
            if [ "$?" -eq 0 ]
            then
                echo -e "Internet Connection" "\t\t\t\t\t\t$C_G[ OK ]$C_END"
                echo -e "$SMTPSERV is AVAILABLE."
                echo -n "Verifing"
                for (( i=0; i<5; i++ ))
                do
                    echo -n ".."
                    sleep 1
                done
                echo
            else
                echo -e "Internet Connection:" "\t\t\t\t\t\t$C_R[ FAIL ]$C_END" ""
                echo -e "$SMTPSERV is Unavialable."
                echo -e "Check your Network settings."
                echo "PING"
                #exit 0
            fi
    mxdomain_old=$mxdomain
fi

# Checking Expect is available or not.

expect -v >/dev/null
		if [ "$?" -eq 0 ]
		then
			echo -e "Expect:" "\t\t\t\t\t\t\t$C_G[ OK ]$C_END" ""
		else
			echo -e echo -e "Expect:" "\t\t\t\t\t\t\t$C_R[ FAIL ]$C_END" ""
			echo -e "sudo yum install -y expect"
		fi
COUNT=0

MAFR="MAIL FROM: <dms@easysol.net>"
MATO="RCPT TO: <$mxmail>"

# variablies declared for not get escaped in the next cat command, where
# we set the $MAFR in the expect script.

cat << __EOF > e-veri1
#!/bin/expect
#:
#: Discription: Expect Script to Verify/Validate the G-Mail Adresses.
#:


set VMAFR "$MAFR"
set VMATO "$MATO"
set VSMTPSERV "$SMTPSERV"

	spawn nc "\$VSMTPSERV" 25
			expect "ESMTP"
			send "HELO easysol.net\r"
			expect "service"
			send "\$VMAFR\r"
			expect "OK"
			send "\$VMATO\r"
			expect "OK"
			send "quit\r"

expect eof
__EOF

# Running the expect script and extracting the Results.txt

expect e-veri1 > Results.txt
grep 550 Results.txt >/dev/null

		if [ "$?" -eq 0 ]
		then
			echo -e "$LINE" >> invalidemails.csv #>/dev/null	#invalid E-mails
		else
			echo -e "$LINE" >> validemails.csv
		fi
}
done

echo -e "Valid E-mail have been saved to $C_R[ validemails.csv ]$C_END"

# END
