#!/bin/bash

set -eu

TOOL_USER='pi'
TOOL_GROUP='pi'
WEB_USER='www-data'
WEB_GROUP='www-data'
HOME_DIR="/home/${TOOL_USER}"
TOOL_DIR="${HOME_DIR}/otasuke"
WEB_DIR="/var/www/html/otasuke"

SCRIPT_DIR=$(cd $(dirname $0) ; pwd ;)
SEP=$(for i in $(seq 1 $(tput cols)) ; do echo -n '#' ; done ; echo ;)


# ==========================================================================================
echo -e "\n${SEP}\nOSとroot権限の確認 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
set -x
cat /etc/os-release | grep -i rasp || (echo 'OS が Raspbianではないため、終了します' ; exit 1 ;)
if [ "$(sudo whoami)" != "root" ]; then echo 'root権限がないため、終了します' ; exit 1 ; fi
set +x
# ==========================================================================================

# ==========================================================================================
echo -e "\n${SEP}\n${TOOL_DIR} のデプロイ 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
set -x
sudo mkdir -p $TOOL_DIR
sudo /bin/cp -ar $SCRIPT_DIR/tool/. $TOOL_DIR/
sudo chown -R ${TOOL_USER}:${TOOL_GROUP} $TOOL_DIR
set +x
# ==========================================================================================

# ==========================================================================================
echo -e "\n${SEP}\n${WEB_DIR} のデプロイ 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
set -x
sudo mkdir -p $WEB_DIR
sudo /bin/cp -ar $SCRIPT_DIR/web/. $WEB_DIR/
sudo chown -R ${WEB_USER}:${WEB_GROUP} $WEB_DIR
sudo chmod 606 $WEB_DIR/txt/*
set +x
# ==========================================================================================

# ==========================================================================================
echo -e "\n${SEP}\ncronの登録 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
set -x
sudo grep 'otasuke' /var/spool/cron/crontabs/$TOOL_USER \
 || sudo sh -c "echo '*/1 * * * * bash ${SCRIPT_DIR}/otasuke.sh > /dev/null 2>&1' \
 >> /var/spool/cron/crontabs/pi"
set +x
# ==========================================================================================

# ==========================================================================================
echo -e "\n${SEP}\napache2 の設定 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
which apache2 \
 || (echo 'apache2のインストールを開始します' ; sudo apt-get install apache2 ;)
which chkconfig \
 || (echo 'chkconfigのインストールを開始します' ; sudo apt-get install chkconfig ;)
sudo /etc/init.d/apache2 status \
 || sudo /etc/init.d/apache2 start
chkconfig apache2 on
sudo grep 'Listen 365' /etc/apache2/ports.conf \
 || sudo sed -i.bak -E -e '/^Listen [0-9]+$/a Listen 365' /etc/apache2/ports.conf
sudo cp -a $SCRIPT_DIR/conf/002-otasuke.conf /etc/apache2/sites-available/
sudo a2ensite 002-otasuke
sudo /etc/init.d/apache2 restart
# ==========================================================================================

# ==========================================================================================
echo -e "\n${SEP}\nopen-jtalk の設定 開始\n${SEP}" ; sleep 2 ;
# ==========================================================================================
which open_jtalk \
 || (echo 'open-jtalkのインストールを開始します' ; sudo apt-get install open-jtalk ;)
if [ -d '/usr/share/hts-voice' ]; then
    wget http://downloads.sourceforge.net/project/mmdagent/MMDAgent_Example/MMDAgent_Example-1.6/MMDAgent_Example-1.6.zip
    unzip MMDAgent_Example-1.6.zip
    sudo cp -R $SCRIPT_DIR/MMDAgent_Example-1.6/Voice/mei /usr/share/hts-voice/
    rm -rf MMDAgent_Example-1.6*
fi
bash $SCRIPT_DIR/mei_say.sh 'デプロイが完了しました'
bash $SCRIPT_DIR/mei_say.sh 'パイソンスリーは自分で入れてくださいね'
# ==========================================================================================

exit 0
