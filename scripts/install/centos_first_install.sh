
IP=$1

if [[ $IP ]];then
	echo "using given IP"
	IP90="$IP:9090"
else
	IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
  IP90="$IP:9090"
	echo "IP:$IP"
fi

sudo yum -y install ant tar sed bzip2 git php perl wget zip unzip httpd patch
setenforce 0
service iptables stop

BASE=/opt
LOCAL=/opt/local

sudo -u nobody bash -c : && RUNAS="sudo -u $SUDO_USER"

$RUNAS bash << _
#git clone https://github.com/kmullins/i2b2-install
cd $LOCAL
source /opt/i2b2-install/scripts/install/install.sh
download_i2b2_source $LOCAL
unzip_i2b2core $LOCAL
_

#BASE=$(pwd)
source /opt/i2b2-quickstart/scripts/install/centos_sudo_install.sh
install_httpd
install_i2b2webclient $LOCAL $IP90
install_postgres

$RUNAS bash << _
if psql -U postgres -lqt | cut -d \| -f 1 |grep "i2b2";then
	echo "i2b2 db exists in postgres"
else
	source /opt/i2b2-quickstart/scripts/postgres/load_data.sh $(pwd)
	create_db_schema $(pwd) "-U postgres";
	load_demo_data $(pwd) " -d i2b2 " $IP
fi
_

$RUNAS bash << _
#check_homes_for_install $(pwd)
#compile_i2b2core $(pwd)
#run_wildfly $(pwd)

source /opt/i2b2-quickstart/scripts/install/install.sh
check_homes_for_install $LOCAL
compile_i2b2core $LOCAL
run_wildfly $LOCAL

_
