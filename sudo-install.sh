#git clone https://github.com/waghsk/i2b2-install
if [ -d /var/lib/pgsql9/data/ ]
then echo "postgres already installed"
else
sudo yum install git postgresql-server php perl
sudo service postgresql initdb
sudo chkconfig postgresql on 
sudo cp postgresql/pg_hba.conf  /var/lib/pgsql9/data/
sudo service postgresql start
cp httpd/httpd.conf /etc/httpd/conf/
sudo chkconfig httpd on 
sudo service httpd start
fi

echo "drop database i2b2;" |psql -U postgres

export BASE="/home/ec2-user/i2b2-install"
cat create_database.sql |psql -U postgres 
cat create_users.sql |psql -U postgres i2b2
cd "$BASE/data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata/"
echo "pwd:$PWD"
cat scripts/crc_create_datamart_postgresql.sql|psql -U postgres i2b2
cat scripts/crc_create_query_postgresql.sql|psql -U postgres i2b2
cat scripts/crc_create_uploader_postgresql.sql|psql -U postgres i2b2
cat scripts/expression_concept_demo_insert_data.sql|psql -U postgres i2b2
cat scripts/expression_obs_demo_insert_data.sql|psql -U postgres i2b2
for x in $(ls scripts/postgresql/); do cat scripts/postgresql/$x|psql -U postgres i2b2;done;

cd "$BASE/data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Hivedata/"
for x in $(ls scripts/*postgresql*); do echo "SET search_path TO i2b2hivedata;">/tmp/t ;cat scripts/$x>>/tmp/t;cat /tmp/t|psql -U postgres i2b2 ;done;
for x in $(ls scripts/*postgresql*); do echo "SET search_path TO i2b2hivedata;">/tmp/t ;cat $x>>/tmp/t;cat /tmp/t|psql -U postgres i2b2 ;done;

cd ../Pmdata/
for x in $(ls scripts/*postgresql*); do echo $x;cat scripts/$x|psql -U postgres i2b2 ;done;
cat scripts/pm_access_insert_data.sql|psql -U postgres i2b2
#for x in $(ls scripts/*postgresql*); do echo "SET search_path TO i2b2pm;">/tmp/t ;cat $x>>/tmp/t;cat /tmp/t|psql -U postgres i2b2 ;done;
#echo "SET search_path TO i2b2pm;">/tmp/t ;cat scripts/pm_access_insert_data.sql>>/tmp/t;cat /tmp/t|psql -U postgres i2b2

echo "grant all privileges on all tables in schema i2b2hive to i2b2hive;"|psql -U postgres i2b2

cd "$BASE"
#cat grant_privileges.sql |psql -U postgres i2b2

if [ -d /var/www/html/admin ]
then echo "admin folder already exists"
else 
	cp -rv server-common/admin /var/www/html/
	cp i2b2webclient-1707/webclient /var/www/html/
fi
#cd "$BASE"
#find -L . -type f -print | xargs sed -i 's/8080/9090/g'
