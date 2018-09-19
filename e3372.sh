#!/bin/sh 

MODEM_IP="192.168.9.1" 
curl -s -X GET "http://$MODEM_IP/api/webserver/SesTokInfo" > ses_tok.xml
COOKIE=`grep "SessionID=" ses_tok.xml | cut -b 10-147`
TOKEN=`grep "TokInfo" ses_tok.xml | cut -b 10-41` 

curl -s -X GET "http://$MODEM_IP/api/device/information" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml" > modem_status.xml 

curl -s -X GET "http://$MODEM_IP/api/device/signal" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml" >> modem_status.xml

wmode=$(cat modem_status.xml | grep workmode | sed -e 's/<[^>]*>//g')

rssi=$(cat modem_status.xml | grep rssi | sed -e 's/<[^>]*>//g')

echo "mode: $wmode"
echo "signal: $rssi"
