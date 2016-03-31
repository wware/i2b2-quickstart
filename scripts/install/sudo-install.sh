#git clone https://github.com/waghsk/i2b2-install


sudo yum -y install git php perl

install_postgres(){
	if [ -d /var/lib/pgsql94/data/ ]
	then echo "postgres already installed"
	else
		sudo yum install http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm
		sudo yum install yum install postgresql94-server postgresql94-contrib

		sudo service postgresql94 initdb
		sudo chkconfig postgresql94 on 
		sudo cp conf/postgresql/pg_hba.conf  /var/lib/pgsql94/data/
		sudo service postgresql94 start
		
	fi
}

install_httpd(){		
		cp conf/httpd/httpd.conf /etc/httpd/conf/
		sudo chkconfig httpd on 
		sudo service httpd start
}

load_demo_data(){

	echo "drop database i2b2;" |psql -U postgres

	BASE="/home/ec2-user/i2b2-install"
	DATA_BASE="$BASE/unzipped_packages/i2b2-data-master"
	cat create_database.sql |psql -U postgres 
	cat create_users.sql |psql -U postgres i2b2

	cd "$DATA_BASE/edu.harvard.i2b2.data/Release_1-7/NewInstall/Crcdata/"
	echo "pwd:$PWD"
	cat scripts/crc_create_datamart_postgresql.sql|psql -U postgres i2b2
	cat scripts/crc_create_query_postgresql.sql|psql -U postgres i2b2
	cat scripts/crc_create_uploader_postgresql.sql|psql -U postgres i2b2
	cat scripts/expression_concept_demo_insert_data.sql|psql -U postgres i2b2
	cat scripts/expression_obs_demo_insert_data.sql|psql -U postgres i2b2
	for x in $(ls scripts/postgresql/); do cat scripts/postgresql/$x|psql -U postgres i2b2;done;

	cd "$DATA_BASE/edu.harvard.i2b2.data/Release_1-7/NewInstall/Hivedata/"
	mkdir ~/tmp
	for x in "create_postgresql_i2b2hive_tables.sql" "work_db_lookup_postgresql_insert_data.sql" "ont_db_lookup_postgresql_insert_data.sql" "im_db_lookup_postgresql_insert_data.sql" "crc_db_lookup_postgresql_insert_data.sql"
	do echo "SET search_path TO i2b2hive;">~/tmp/t ;cat scripts/$x>>~/tmp/t;cat ~/tmp/t|psql -U postgres i2b2 ;done;

	cd ../Pmdata/
	for x in "create_postgresql_i2b2pm_tables.sql" "create_postgresql_triggers.sql"
	do echo $x;cat scripts/$x|psql -U postgres i2b2 ;done;
	cat scripts/pm_access_insert_data.sql|psql -U postgres i2b2

	echo "grant all privileges on all tables in schema i2b2hive to i2b2hive;"|psql -U postgres i2b2

	cd "$DATA_BASE/edu.harvard.i2b2.data/Release_1-7/NewInstall/Metadata/"
	for x in $(ls scripts/*postgresql*); do echo $x;cat $x|psql -U postgres i2b2 ;done;
	for x in $(ls demo/scripts/*.sql); do echo $x;cat $x|psql -U postgres i2b2 ;done;
	for x in $(ls demo/scripts/postgresql/*); do echo $x;cat $x|psql -U postgres i2b2 ;done;
	cat scripts/pm_access_insert_data.sql|psql -U postgres i2b2

	cd "$DATA_BASE/edu.harvard.i2b2.data/Release_1-7/NewInstall/Workdata/";
	x="scripts/create_postgresql_i2b2workdata_tables.sql"; echo $x;cat $x|psql -U postgres i2b2;
	x="scripts/workplace_access_demo_insert_data.sql"; echo $x;cat $x|psql -U postgres i2b2;

	cd "$BASE"
	cat grant_privileges.sql |psql -U postgres i2b2
}

install_webclient(){

	BASE="/home/ec2-user/i2b2-install"
	WC_SRC_BASE=$BASE/unzipped_packages/i2b2-webclient-master
	if [ -d "$WC_SRC_BASE" ]
	then "echo webclient already unzipped"
	else
		cd $BASE/unzipped_files 
		unzip zip_files/i2b2webclient-1707.zip

	fi

	if [ -d /var/www/html/webclient ]
	then echo "webclient folder already exists"
	else 
		cp -rv server-common/admin /var/www/html/
		cp -rv $WC_SRC_BASE/ /var/www/html/webclient/
		cp conf/webclient/i2b2_config_data.js /var/www/html/webclient/
		cp conf/admin/i2b2_config_data.js /var/www/html/admin/

	fi
	#cd "$BASE"
#
#find -L . -type f -print | xargs sed -i 's/9090/9090/g'
}
#load_demo_data
#install_webclient
install_httpd
