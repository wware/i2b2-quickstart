installs i2b2 hive and webclient on amazon webservice vm

git clone https://github.com/waghsk/i2b2-install.git

cd i2b2-install

sudo sh sudo-install.sh

Ctrl-X

sh install.sh

#############
to allow remote connections to database add 

listen_addresses='*'

to /var/lib/pgsql9/data/postgresql.conf
