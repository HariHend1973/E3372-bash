#!/bin/sh 

MODEM_IP="192.168.9.1" 
curl -s -X GET "http://$MODEM_IP/api/webserver/SesTokInfo" > ses_tok.xml
COOKIE=`grep "SessionID=" ses_tok.xml | cut -b 10-147`
TOKEN=`grep "TokInfo" ses_tok.xml | cut -b 10-41` 

curl -s -X POST "http://$MODEM_IP/api/sms/send-sms" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml" -d "<?xml version='1.0' encoding='UTF-8'?><request><Index>-1</Index><Phones><Phone>363</Phone></Phones><Sca></Sca><Content>USAGE</Content><Length>5</Length><Reserved>1</Reserved><Date>-1</Date></request>" > modem_status.xml

cat modem_status.xml

