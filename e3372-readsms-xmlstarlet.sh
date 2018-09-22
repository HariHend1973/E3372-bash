#!/bin/bash 

MODEM_IP="192.168.9.1" 
curl -s -X GET "http://$MODEM_IP/api/webserver/SesTokInfo" > ses_tok.xml
COOKIE=`grep "SessionID=" ses_tok.xml | cut -b 10-147`
TOKEN=`grep "TokInfo" ses_tok.xml | cut -b 10-41` 

curl -s -X POST "http://$MODEM_IP/api/sms/sms-list" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml" -d "<request><PageIndex>1</PageIndex><ReadCount>10</ReadCount><BoxType>1</BoxType><SortType>0</SortType><Ascending>0</Ascending><UnreadPreferred>1</UnreadPreferred></request>" > modem_status.xml

#cat modem_status.xml

readarray -t array_phone <<< "$(xmlstarlet sel -t -m "//Phone" -v . -n modem_status.xml)"

readarray -t array_content <<< "$(xmlstarlet sel -t -m "//Content" -v . -n modem_status.xml)"

for ((i=0; i<${#array_content[@]}; i++ ))
do
    echo -e "------\n${array_phone[$i]}"
    echo -e "------\n${array_content[$i]}"
done
