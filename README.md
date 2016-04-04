installs i2b2 hive and webclient on amazon webservice vm

git clone https://github.com/waghsk/i2b2-install.git

sudo sh scripts/install/centos_first_install.sh 2>&1|tee first.log


#############

to allow remote connections to database add 

listen_addresses='*'

to /var/lib/pgsql9/data/postgresql.conf
