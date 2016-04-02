

yum -y install wget unzip 



sudo -u nobody bash -c : && RUNAS="sudo -u $SUDO_USER"

$RUNAS bash << _
source scripts/install/install.sh
download_i2b2_source $(pwd)
unzip_i2b2core $(pwd)
_

BASE=$(pwd)
source scripts/install/centos_sudo_install.sh
#install_httpd
install_i2b2webclient $(pwd)

#install_i2b2admin
install_postgres


$RUNAS bash << _
if psql -U postgres -lqt | cut -d \| -f 1 |grep "i2b2";then
	echo "i2b2 db exists in postgres"
else
	source scripts/postgres/load_data.sh $(pwd)
fi
source scripts/install/install.sh
check_homes_for_install
compile_i2b2core
run_wildfly
_
