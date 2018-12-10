#!/bin/bash

DIR=$(cd $(dirname $0) ; pwd)
cd $DIR
logfile='otasuke.log'

#現在時刻を取得
now_date=$(date +'%Y-%m-%d')
now_minute=$(date +'%H:%M')
now="${now_date} ${now_minute}"

function create_wav() {
    wav_file=wav/$1
    echo "$2" |  open_jtalk \
    -m /usr/share/hts-voice/mei/mei_normal.htsvoice \
    -x /var/lib/mecab/dic/open-jtalk/naist-jdic \
    -ow $wav_file
}

function check_alarms() {
    # アラーム音がまだ鳴っていれば、実行を中止
    ps aux | grep -v grep | grep 'aplay' \
     && (echo $now 'alarm is ringing' | tee -a $DIR/$logfile ; exit 1 ;)
    txt=$(sudo cat "/var/www/html/otasuke/txt/alarms.txt")
    for line in $txt; do
        if [[ $line = $1 ]]; then
            echo $now 'alarm on because alarm was set___' | tee -a $DIR/$logfile
            return
        fi
    done
    echo $now 'alarm off because alarm was not set' | tee -a $DIR/$logfile
    exit
}

function play_wav() {
    wav_file=wav/$1
    aplay --quiet $wav_file
}

function delete_wav() {
    wav_file=wav/$1
    rm $wav_file
}


# main ======================================================================

# アラームの設定時刻か確認
check_alarms $now_minute

# 各スクリプトの実行
bash get_now.sh
bash get_weather.sh
bash get_bustime.sh
bash get_garbage.sh

# 読み上げ情報の取得
voice1=$(tail -1 txt/now.txt)
voice2=$(tail -1 txt/weather.txt)
voice3=$(tail -1 txt/bustime.txt)
voice4=$(tail -1 txt/garbage.txt)

# 読み上げファイルの定義
file1='now.wav'
file2='weather.wav'
file3='bustime.wav'
file4='garbage.wav'

# 読み上げファイルを作成
create_wav $file1 $voice1 &
create_wav $file2 $voice2 &
create_wav $file3 $voice3 &
create_wav $file4 $voice4 &

# 人を感知するまで音楽を鳴らす
sudo python3 get_humansensor.py
if [[ $(echo $?) = '0' ]]; then
    echo -n $now '$?=0 : music done___' | tee -a $DIR/$logfile
    exit
elif [[ $(echo $?) = '1' ]]; then
    echo -n $now '$?=1 : human got'
elif [[ $(echo $?) = '10' ]]; then 
    echo -n $now '$?=10 : keybord interrupted___' | tee -a $DIR/$logfile
    exit
fi

wait
echo -n "${voice1}___" | tee -a $DIR/$logfile
echo -n "${voice2}___" | tee -a  $DIR/$logfile
echo -n "${voice3}___" | tee -a  $DIR/$logfile
echo -n "${voice4}" | tee -a  $DIR/$logfile
play_wav $file1
play_wav $file2
play_wav $file3
play_wav $file4
#delete_wav $file1
#delete_wav $file2
#delete_wav $file3
#delete_wav $file4

exit 0
