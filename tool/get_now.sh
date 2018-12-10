#!/bin/bash
 
DIR=$(cd $(dirname $0) ; pwd)

#日時を取得
DATE=$(date '+%Y年%-m月%-d日')
TIME=$(date '+%-H時%-M分')

#曜日を取得
WEEK=('日曜日' '月曜日' '火曜日' '水曜日' '木曜日' '金曜日' '土曜日')
DotW=${WEEK[$(date +%w)]}

#日時,曜日をecho
echo -e "現在は、$DATE、$DotW、$TIME、です。" | tee -a $DIR/txt/now.txt

exit
