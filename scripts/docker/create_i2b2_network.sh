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

if [ ! -d $DAP ]; then
	mkdir -p $DAP & echo "created $DAP"
	source $BASE/scripts/install/centos_sudo_install.sh $BASE
	copy_webclient_dir $BASE i2b2-wildfly $DAP

	cp -rv $BASE/conf/httpd/* $DAP
	cp -rv $BASE/conf/docker/i2b2-web/* $DAP
	docker build  -t i2b2/web $DAP/
fi
	
docker run -d  --net i2b2-net -p 443:443 -p 80:80 --name i2b2-web i2b2/web
#docker stop i2b2-web
#docker rm i2b2-web
#docker rmi i2b2/web
