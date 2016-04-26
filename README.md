installs i2b2 hive and webclient on centos vm, amazon webservice and Docker  (see wiki for details)

###Quickstart


git clone https://github.com/waghsk/i2b2-quickstart.git

cd i2b2-quickstart

sudo sh scripts/install/centos_first_install.sh 2>&1|tee first.log

###To test installation

see http://ipaddress/webclient/

###Tips

to allow remote connections to database add 

listen_addresses='*'

to /var/lib/pgsql9/data/postgresql.conf

###To install as docker containers
sudo sh scripts/docker/run_docker_network.sh PUBLIC_IP
