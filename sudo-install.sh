#git clone https://github.com/waghsk/i2b2-install
sudo yum install git postgresql-server php perl
sudo service postgresql initdb
sudo chkconfig postgresql on 
sudo service postgresql start

export BASE="~/i2b2-install/"
sudo cp /postgres/pg_hba.conf  /var/lib/pgsql9/data/
cat create_database.sql |psql -U postgres 
cat create_users.sql |psql -U postgres i2b2
cd "$BASE/data/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata/"
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
for x in $(ls scripts/*postgresql*); do echo "SET search_path TO i2b2pm;">/tmp/t ;cat $x>>/tmp/t;cat /tmp/t|psql -U postgres i2b2 ;done;s
echo "SET search_path TO i2b2pm;">/tmp/t ;cat scripts/pm_access_insert_data.sql>>/tmp/t;cat /tmp/t|psql -U postgres i2b2

grant all privileges on all tables in schema i2b2hive to i2b2hive;

cd "$BASE"
find -L . -type f -print | xargs sed -i 's/8080/9090/g'
