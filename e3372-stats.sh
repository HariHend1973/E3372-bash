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
# Totao Connect Time
#------------------------------
tct_secs=$TotalConnectTime
printf 'Total Connect Time : %d days: %02d hours: %02d minutes: %02d sseconds\n' $((tct_secs/86400)) $((tct_secs%86400/3600)) $((tct_secs%3600/60)) $((tct_secs%60))

#cat modem_status.xml
#------------------------------
# Current Uploae
#------------------------------
if [ $CurrUpload -lt 1024 ]; then
    echo "Current Upload: ${CurrUpload}B"
elif [ $CurrUpload -lt 1048576 ]; then
    K=$(echo  "scale=2; $CurrUpload/1024" | bc)
    echo "Current Upload: $K KiB"
elif [ $CurrUpload -lt 1073741824 ]; then
    M=$(echo  "scale=2; $CurrUpload/1048576" | bc)
    echo "Current Upload: $M MiB"
else
    G=$(echo  "scale=2; $CurrUpload/1073741824" | bc)
    echo "Current Upload: $G GiB"
fi

#------------------------------
# Current Downloae
#------------------------------
if [ $CurrDownload -lt 1024 ]; then
    echo "Current Dowbload : ${CurrDownload}B"
elif [ $CurrDownload -lt 1048576 ]; then
    K=$(echo  "scale=2; $CurrDownload/1024" | bc)
    echo "Current Dowbload : $K KiB"
elif [ $CurrDownload -lt 1073741824 ]; then
    M=$(echo  "scale=2; $CurrDownload/1048576" | bc)
    echo "Current Dowbload : $M MiB"
else
    G=$(echo  "scale=2; $CurrDownload/1073741824" | bc)
    echo "Current Dowbload : $G GiB"
fi

#------------------------------
# Total Upload
#------------------------------
if [ $TotalUpload -lt 1024 ]; then
    echo "Total Upload : ${TotalUpload}B"
elif [ $TotalUpload -lt 1048576 ]; then
    K=$(echo  "scale=2; $TotalUpload/1024" | bc)
    echo "Total Upload : $K KiB"
elif [ $TotalUpload -lt 1073741824 ]; then
    M=$(echo  "scale=2; $TotalUpload/1048576" | bc)
    echo "Total Upload : $M MiB"
else
    G=$(echo  "scale=2; $TotalUpload/1073741824" | bc)
    echo "Total Upload : $G GiB"
fi

#------------------------------
# Total Download
#------------------------------
if [ $TotalDownload -lt 1024 ]; then
    echo "Total Download : ${TotalDowbload}B"
elif [ $TotalDownload -lt 1048576 ]; then
    K=$(echo  "scale=2; $TotalDownload/1024" | bc)
    echo "Total Doenload : $K KiB"
elif [ $TotalDownload -lt 1073741824 ]; then
    M=$(echo  "scale=2; $TotalDownload/1048576" | bc)
    echo "Total Doenload : $M MiB"
else
    G=$(echo  "scale=2; $TotalDownload/1073741824" | bc)
    echo "Total Doenload : $G GiB"
fi
