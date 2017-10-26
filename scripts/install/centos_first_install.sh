
IP=$1


if [[ $IP ]];then
	echo "using given IP"
	IP90="$IP:9090"
else
	IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
	IP90="$IP:9090"
fi

sudo yum -y install ant tar sed bzip2 git php perl wget zip unzip httpd patch
setenforce 0
service iptables stop


BASE=/opt
LOCAL=$BASE/local
cd $LOCAL
pwd

sudo -u nobody bash -c : && RUNAS="sudo -u $SUDO_USER"

$RUNAS bash << _
echo $LOCAL
cd $LOCAL
git clone https://github.com/kmullins/i2b2-quickstart.git 

 [[ -d i2b2-quickstart ]] || echo "Check i2b2quickstart Clone"

echo " running install" 
source $LOCAL/i2b2-quickstart/scripts/install/install.sh
if [ $? -ne 0 ]
then
	echo "#############  Errors running /scripts/install/install.sh ##########"
fi

download_i2b2_source $LOCAL
if [ $? -ne 0 ]
then
	echo "#############  Problem with download_12b2_sources ##########"
fi

unzip_i2b2core $LOCAL
if [ $? -ne 0 ]   
then
	echo "#############  Problem with unzip i2b2core ##########"
fi
_


source $LOCAL/i2b2-quickstart/scripts/install/centos_sudo_install.sh
install_httpd
install_i2b2webclient $LOCAL $IP90

#install_i2b2admin
install_postgres

$RUNAS bash << _
if psql -U postgres -lqt | cut -d \| -f 1 |grep "i2b2";then
	echo "i2b2 db exists in postgres"
else
	source $LOCAL/i2b2-quickstart/scripts/postgres/load_data.sh $(pwd)
	create_db_schema $(pwd) "-U postgres";

fi
_



$RUNAS bash << _
source $LOCAL/i2b2-quickstart/scripts/install/install.sh
check_homes_for_install $(pwd)
compile_i2b2core $(pwd)  
run_wildfly $(pwd)

_



