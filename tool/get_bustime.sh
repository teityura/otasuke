#!/bin/bash

#現在時刻を取得
now_week=$(date +'w')
now_hour=$(date +'%-H')
now_minute=$(date +'%-M')

#アラームを確認
FILE=$(cat "/var/www/html/otasuke/txt/bustime.txt")
DIR=$(cd $(dirname $0) ; pwd)

#現在時刻から直近3件の発車時刻をecho
function echo_bustime() {
    echo -n 'バスの発車時刻は、'
    cnt=0
    for line in $FILE; do
        line_w=$(echo $line | awk -F ':' '{print $1}')        #平日か土日か取得
        if [[ (($line_w = '平日') && (1 -le  $now_week && $now_week -le 5)) || 
              (($line_w = '土曜') && ($now_week = 1)) || 
              (($line_w = '日曜') && ($now_week = 0)) ]]; then
            line_h=$(echo $line | awk -F ':' '{print $2}' | sed -e 's/^0//g')
            line_m=$(echo $line | awk -F ':' '{print $3}' | sed -e 's/^0//g')
            if [[ ($line_h -eq $now_hour) && 
                  ($line_m -ge $now_minute) || 
                  ($line_h -gt $now_hour) ]]; then
                echo -n "$line_h時$line_m分、"
                cnt=$(expr $cnt + 1)  
                if [[ $cnt -eq 3 ]]; then break; fi
            fi
        fi
    done
    return 0
}

bustime=$(echo_bustime)

echo "$bustimeです。" | tee -a $DIR/txt/bustime.txt

exit
