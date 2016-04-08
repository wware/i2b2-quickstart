#docker network create -d bridge i2b2-net
BASE=$1
DOCKER_HOME=$BASE/local/docker



source $BASE/scripts/install/install.sh $BASE
check_homes_for_install $BASE
#compile_i2b2core $BASE
#run_wildfly $BASE

download_i2b2_source $BASE
unzip_i2b2core $BASE
echo "PWD;$(pwd)"

#Docker App Path
DAP=$DOCKER_HOME/i2b2-web

if [ -d $DAP ]; then
	echo "found $DAP"
else
	mkdir -p "$DAP" & echo "created $DAP"
	source $BASE/scripts/install/centos_sudo_install.sh $BASE
	copy_webclient_dir $BASE i2b2-wildfly $DAP

	cp -rv $BASE/conf/httpd/* $DAP
	cp -rv $BASE/conf/docker/i2b2-web/* $DAP
	docker build  -t i2b2/web $DAP/
	docker run -d  --net i2b2-net -p 443:443 -p 80:80 --name i2b2-web i2b2/web
fi

DAP=$DOCKER_HOME/i2b2-pg

if [ -d $DAP ]; then
	echo "found $DAP"
else
	mkdir -p "$DAP" & echo "created $DAP"
	docker run --net i2b2-net --name i2b2-pg -d -p 5432:5432 -e 'DB_USER=i2b2' -e 'DB_PASS=pass' -e 'DB_NAME=i2b2' centos/postgresql
	source $BASE/scripts/postgres/load_data.sh $(pwd)
        create_db_schema $(pwd) "-U i2b2 postgres";
        load_demo_data $(pwd) i2b2-web	
fi	

#docker stop i2b2-web
#docker rm i2b2-web
#docker rmi i2b2/web
