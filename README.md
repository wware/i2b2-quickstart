installs i2b2 hive and webclient on centos vm, amazon webservice and Docker  (see wiki for details)

###Quickstart

cd i2b2-install

git clone https://github.com/waghsk/i2b2-quickstart.git

sudo sh scripts/install/centos_first_install.sh 2>&1|tee first.log

###To test installation

see http://ipaddress/webclient/

###Tips

to allow remote connections to database add 

listen_addresses='*'

to /var/lib/pgsql9/data/postgresql.conf
