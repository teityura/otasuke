#!/bin/bash

w=$(date '+%w')
weeks=('日' '月' '火' '水' '木' '金' '土')
DIR=$(cd $(dirname $0) ; pwd)

#ゴミの種類を確認
FILE=$(cat "/var/www/html/otasuke/txt/garbage.txt")
for i in $FILE; do
    if [[ $(echo $i | awk -F ':' '{print $1}') = $(echo ${weeks[$w]}) ]]; then
        garbage=$(echo $i | awk -F ':' '{print $2}')
    fi
done

#ゴミの種類をecho
echo -e "今日のゴミは、$garbage、です。" | tee -a $DIR/txt/garbage.txt

exit
