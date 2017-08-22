#!/bin/sh
BASE=$1
DOCKER_HOME=$BASE/local/docker

DIP=$2
alias docker=" docker"

docker network create i2b2-net

echo "PWD;$(pwd)"

	source $BASE/scripts/install/install.sh $BASE
	check_homes_for_install $BASE
	download_i2b2_source $BASE
	unzip_i2b2core $BASE
#Docker App Path
APP=i2b2-wildfly
DAP=$DOCKER_HOME/$APP
if [ -d $DAP ]; then
	echo "found $DAP"
else
	mkdir -p "$DAP" & echo "created $DAP"
	
	mkdir -p $DAP/jbh
	
	cp -rv $BASE/conf/docker/$APP/* $DAP

	
	JBOSS_HOME=$DAP/jbh
	echo "JBOSS_HOME=$JBOSS_HOME"
	copy_axis_to_wildfly $JBOSS_HOME	
	copy_axis2_to_wildfly_i2b2war $BASE $JBOSS_HOME	
	#cp i2b2-quickstart/unzipped_packages/i2b2-core-server-master/edu.harvard.i2b2.server-common/etc/axis2/axis2.xml $DAP/jbh/standalone/deployments/i2b2.war/WEB-INF/conf/axis2.xml

	compile_i2b2core $BASE $JBOSS_HOME $JBOSS_HOME /opt/jboss/wildfly
#run_wildfly $BASE
	
	#copy datasource config for each cell into datatype
	#cells: crc ont workspace im
	#for DBT in postgres oracle mssql;
	#do
		#cp conf/ontology/etc-jboss/$DBT/ont-ds.xml $DAP/datasource_config/$DBT/
		#cp conf/pm/etc-jboss/$DBT/ont-ds.xml $DAP/datasource_config/$DBT/
		#cp conf/im/etc-jboss/$DBT/ont-ds.xml $DAP/datasource_config/$DBT/
		#cp conf/crc/etc-jboss/$DBT/ont-ds.xml $DAP/datasource_config/$DBT/
		#cp conf/workplace/etc-jboss/$DBT/ont-ds.xml $DAP/datasource_config/$DBT/
		
	#done
	
	#this step is moved to the prescript
#	cd  $DAP/jbh/standalone
#	for x in $(find -iname *.xml); do
#		echo $x
		#only change pg-datasourc to i2b2-pg
#		sed -i  s/localhost:5432/i2b2-pg:5432/ "$x"
#		sed -i  s/localhost:5432/#{systemProperties['DS_IP']:#{systemProperties['DS_PORT']}/ "$x"
#		sed -i  s/localhost:5432/\${DS_IP}:\${DS_PORT}/ "$x"
#		sed -i  s/127.0.0.1/$DIP/ "$x"
#		sed -i  s/9090/8080/ "$x"
#	done
#	PWD=$(pwd)
#	CONFD=/opt/jboss/wildfly/standalone/configuration
#	Check if this step is required
	for x in $(find -iname *.properties); do
		echo $x
#		sed -i  s/localhost/i2b2-pg/ "$x"
#		sed -i  s/127.0.0.1/$DIP/ "$x"
		sed -i  s/9090/8080/ "$x"
	done
	cd  $DAP/jbh/standalone/
	tar -cvjf deploy.tar.bz2 deployments/*
	
	cd  $DAP/jbh/standalone/
	tar -cvjf config.tar.bz2 configuration/*
	
	cd $BASE


	docker stop $APP;docker rm $APP; docker rmi i2b2/$APP
	docker build  -t i2b2/i2b2-wildfly $DAP/
	docker run -d -p 8080:8080 --net i2b2-net --name $APP i2b2/i2b2-wildfly
	
	#docker run -it jboss/wildfly /opt/jboss/wildfly/bin/domain.sh -b 0.0.0.0 -bmanagement 0.0.0.0

fi

APP=i2b2-web
DAP="$DOCKER_HOME/$APP"

if [ -d $DAP ]; then
	echo "found $DAP"
else
	mkdir -p "$DAP" && echo "created $DAP"
	echo "BASE:$BASE DIP:$DIP DAP:$DAP"
	source $BASE/scripts/install/centos_sudo_install.sh $BASE
	copy_webclient_dir $BASE $DIP $DAP

	cp -rv $BASE/conf/httpd/* $DAP
	cp -rv $BASE/conf/docker/$APP/* $DAP
	sed -i  s/9090/8080/ $DAP/i2b2_proxy.conf
#	sed -i  s/localhost/$DIP/ $DAP/i2b2_proxy.conf
	sed -i  s/localhost/i2b2-wildfly/ $DAP/i2b2_proxy.conf

	docker stop $APP;docker rm $APP; docker rmi i2b2/$APP
	docker build  -t i2b2/i2b2-web $DAP/
	docker run -d  -p 443:443 -p 80:80 --net i2b2-net --name i2b2-web i2b2/i2b2-web /run-httpd.sh localhost
fi


APP=i2b2-pg
DAP="$DOCKER_HOME/$APP"


if [ -d $DAP ]; then
	echo "found $DAP"
else
	mkdir -p "$DAP" & echo "created $DAP"
	docker stop i2b2-pg-empty;docker rm i2b2-pg-empty; docker rmi i2b2/i2b2-pg-empty
	docker stop $APP;docker rm $APP; docker rmi i2b2/$APP

#	export POSTGRES_PASSWORD='pass'
#	export POSTGRES_USER='i2b2'
#	export POSTGRES_DB='i2b2'
	export PGIP=0.0.0.0
		
	
	cp -rv $BASE/conf/docker/$APP/* $DAP
	
	docker build  -t i2b2/i2b2-pg-empty $DAP/
	docker run -d  -p 5432:5432 --net i2b2-net --name i2b2-pg   -e 'DB_USER=i2b2' -e 'DB_PASS=pass' -e 'DB_NAME=i2b2' i2b2/i2b2-pg-empty

#	docker run --net i2b2-net --name $APP -d -p 5432:5432 -v /var/lib/pgsql -e 'DB_USER=i2b2' -e 'DB_PASS=pass' -e 'DB_NAME=i2b2' centos/postgresql
#	docker ps
#	#DIP=$(docker inspect --format '{{ index .NetworkSettings "Networks" "i2b2-net" "IPAddress"}} ' i2b2-pg)
	source $BASE/scripts/postgres/load_data.sh $(pwd) 

	USERT=" -U i2b2 -d i2b2 -h $PGIP ";
	echo "USERT=$USERT"
#	#echo "\dt+;"|psql $USERT
	sleep 15
	export PGPASSWORD=demouser;echo "\dt+;"|psql -h $PGIP -U i2b2 -d i2b2
	create_db_schema $(pwd) "$USERT";
        load_demo_data $(pwd) " -h $PGIP -d i2b2 " $DIP

	#docker rm -f i2b2/i2b2-pg
	#docker run -d  -p 5432:5432 --net i2b2-net --name i2b2-pg   i2b2/i2b2-pg:latest
	#sleep 5;
	#docker tag i2b2
	CID=$(docker ps -aqf "name=i2b2-empty")
	docker commit $CID i2b2/i2b2-pg
	docker exec -it i2b2-pg bash -c "export PUBLIC_IP=$IP_ADD;sh update_pm_cell_data.sh; "


fi


