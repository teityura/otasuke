#!/bin/bash

DIR=$(cd $(dirname $0) ; pwd)

#ページ全体を変数に格納
PAGE=$(curl -s https://weather.yahoo.co.jp/weather/jp/13/4410/html)
 
#日付,天気,最高気温,最低気温を取得
date=$(echo -e "$PAGE" | grep -E 'date' | head -1 | sed -e 's/<[^>]*>//g' | awk '{print $1}')
weather=$(echo -e "$PAGE" | grep -E 'pict' | head -1 | sed -e 's/<[^>]*>//g' | awk '{print $1}')
high=$(echo -e "$PAGE" | grep high | grep class | head -1 | awk -F '[<>]' '{print $5}')	#<li class="high"><em>18</em>℃[+3]</li>
low=$(echo -e "$PAGE" | grep low | grep class | head -1 | awk -F '[<>]' '{print $5}')		#<li class="low"><em>18</em>℃[+3]</li>

#時間ごとの降水確率を取得する
function echo_precip_perHour() {
    precip_array=($(echo -e "$PAGE" | grep precip -A 6 | head -6 | tail -4 | sed -e 's/<[^>]*>//g' | awk '{print $1}' | sed -e 's/\-\-\-/\-1/g' | sed -e 's/％//g'))
    time_array1=($(echo -e "$PAGE" | grep time -A 5 | head -6 | tail -4 | sed -e 's/<[^>]*>//g' | awk '{print $1}' | awk -F '-' '{print $1}'))
    time_array2=($(echo -e "$PAGE" | grep time -A 5 | head -6 | tail -4 | sed -e 's/<[^>]*>//g' | awk '{print $1}' | awk -F '-' '{print $2}'))
    echo -n '降水確率は、'
    for i in $(seq 0 $(expr ${#precip_array[@]} - 1)); do
        if [[ ${precip_array[i]} -eq -1 ]]; then
                continue
        fi
        echo -n "${time_array1[i]}時から${time_array2[i]}時までは、${precip_array[i]}パーセント、"
    done
    return 0
}

#降水確率が50%を超える時間帯があれば、傘を持っていくように言う
function echo_umbrella() {
    precip_array=($(echo -e "$PAGE" | grep precip -A 6 | head -6 | tail -4 | sed -e 's/<[^>]*>//g' | awk '{print $1}' | grep -v "\-\-\-" | sed -e 's/％//g'))
    for i in ${precip_array[@]}; do 
        if [[ $i -ge 50 ]]; then
            flag=1
        fi
    done

    if [[ $flag -eq 1 ]]; then
        echo '今日は傘を持って行きましょう！！'
    fi
    return 0
}

precip_perHour=$(echo_precip_perHour)
umbrella=$(echo_umbrella)

#天気をecho
echo -e "天気は、$weather、最高気温は${high}度、最低気温は、${low}度です。$precip_perHourです。$umbrella" | tee -a $DIR/txt/weather.txt

exit
