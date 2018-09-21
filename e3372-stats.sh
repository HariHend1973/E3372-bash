#!/bin/sh 

MODEM_IP="192.168.9.1" 
curl -s -X GET "http://$MODEM_IP/api/webserver/SesTokInfo" > ses_tok.xml
COOKIE=`grep "SessionID=" ses_tok.xml | cut -b 10-147`
TOKEN=`grep "TokInfo" ses_tok.xml | cut -b 10-41` 

curl -s -X GET "http://$MODEM_IP/api/monitoring/traffic-statistics" -H "Cookie: $COOKIE" -H "__RequestVerificationToken: $TOKEN" -H "Content-Type: text/xml" > modem_status.xml


CurConnTime=$(cat modem_status.xml | grep CurrentConnectTime | sed -e 's/<[^>]*>//g')


CurrUpload=$(cat modem_status.xml | grep "<CurrentUpload>" | sed -e 's/<[^>]*>//g')


CurrDownload=$(cat modem_status.xml | grep "<CurrentDownload>" | sed -e 's/<[^>]*>//g')

TotalUpload=$(cat modem_status.xml | grep "<TotalUpload>" | sed -e 's/<[^>]*>//g')

TotalDownload=$(cat modem_status.xml | grep "<TotalDownload>" | sed -e 's/<[^>]*>//g')

TotalConnectTime=$(cat modem_status.xml | grep "<TotalConnectTime>" | sed -e 's/<[^>]*>//g')

#------------------------------
# Current Connect Time
#------------------------------
cct_secs=$CurConnTime
printf 'Current Connect Time : %d days: %02d hours: %02d minutes: %02d sseconds\n' $((cct_secs/86400)) $((cct_secs%86400/3600)) $((cct_secs%3600/60)) $((cct_secs%60))

#------------------------------
# Total Connect Time
#------------------------------
tct_secs=$TotalConnectTime
printf 'Total Connect Time : %d days: %02d hours: %02d minutes: %02d sseconds\n' $((tct_secs/86400)) $((tct_secs%86400/3600)) $((tct_secs%3600/60)) $((tct_secs%60))

#cat modem_status.xml
#------------------------------
# Current Upload
#------------------------------
if [ $CurrUpload -lt 1024 ]; then
    echo "Current Upload : ${CurrUpload}B"
elif [ $CurrUpload -lt 1048576 ]; then
    echo "Current Upload : $((CurrUpload/1024))KiB"
elif [ $CurrUpload -lt 1073741824 ]; then
    echo "Current Upload : $((CurrUpload/1048576))MiB"
else
    echo "Current Upload : $((CurrUpload/1073741824))GiB"
fi

#------------------------------
# Current Downloae
#------------------------------
if [ $CurrDownload -lt 1024 ]; then
    echo "Current Download : ${CurrDowbload}B"
elif [ $CurrDownload -lt 1048576 ]; then
    echo "Current Download : $((CurrDowbload/1024))KiB"
elif [ $CurrDownload -lt 1073741824 ]; then
    echo "Current Download : $((CurrDownload/1048576))MiB"
else
    echo "Current Dowbload : $((CurrDownload/1073741824))GiB"
fi

#------------------------------
# Total Upload
#------------------------------
if [ $TotalUpload -lt 1024 ]; then
    echo "Totak Upload : ${TotalUpload}B"
elif [ $TotalUpload -lt 1048576 ]; then
    echo "Total Upload : $((TotalUpload/1024))KiB"
elif [ $TotalUpload -lt 1073741824 ]; then
    echo "Total Upload : $((TotalUpload/1048576))MiB"
else
    echo "Tital Upload : $((TotalUpload/1073741824))GiB"
fi

#------------------------------
# Total Download
#------------------------------
if [ $TotalDownload -lt 1024 ]; then
    echo "Total Download : ${TotalDowbload}B"
elif [ $TotalDownload -lt 1048576 ]; then
    echo "Total Download : $((TotalDownload/1024))KiB"
elif [ $TotalDownload -lt 1073741824 ]; then
    echo "Total Download : $((TotalDownload/1048576))MiB"
else
    echo "Tital Doenload : $((TotalDownload/1073741824))GiB"
fi


