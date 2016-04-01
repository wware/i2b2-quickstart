sudo -u nobody bash -c : && RUNAS="sudo -u $SUDO_USER"

$RUNAS bash <<_
source $PWD/scripts/install/install.sh
download_i2b2_source
unzip_i2b2core

_
