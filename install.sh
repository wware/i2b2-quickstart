

AXIS_FILE=axis2-1.6.2-war.zip
JDK_FILE=jdk-7u51-linux-x64.tar.gz
ANT_FILE=apache-ant-1.9.6-bin.tar.bz2

PWD=$(pwd)
BASE=$PWD
COM_DIR="$PWD/server-common"
ANT="$PWD/apache-ant-1.9.6/bin/ant"
alias ant=$ANT

JAVA="$PWD/jdk1.7.0_51/bin/java"
export  JAVA_HOME="$PWD/jdk1.7.0_51"
alias java="$JAVA"

JBOSS_FILE=jboss-as-7.1.1.Final.tar.gz
export  JBOSS_HOME="$PWD/jboss-as-7.1.1.Final"


install_java(){
	if [ -f $JDK_FILE ]
	then echo "FOUND $JDK_FILE" 
	else
		curl --create-dirs -L --cookie "oraclelicense=accept-securebackup-cookie; gpw_e24=http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html" http://download.oracle.com/otn-pub/java/jdk/7u51-b13/$JDK_FILE -o $JDK_FILE
		tar -xvzf $JDK_FILE
	fi
}

install_ant(){
	if [ -f $ANT_FILE ]
	then echo "Found $ANT_FILE"
	else
		wget http://apache.mirrors.ionfish.org//ant/binaries/$ANT_FILE
		tar -xvjf $ANT_FILE 
	fi
}


download_axis_jar(){
	if [ -f $AXIS_FILE ]
	then echo ""
	else
		wget https://www.i2b2.org/software/projects/installer/$AXIS_FILE	
	fi	
	if [ -d axis ]; then echo "found axis dir";
	else	
		mkdir axis
		cd axis
		echo "AF:$AXIS_FILE"
		/usr/bin/unzip ../$AXIS_FILE
		cp  axis2.war axis2.zip
	fi
}

download_wildfly(){
	if [ -f $JBOSS_FILE ]
	then echo "FOUND $JBOSS_FILE"
	else
		wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/$JBOSS_FILE
	fi
}

install_wildfly(){
	
	if [ -d $JBOSS_HOME ]
	then echo "FOUND $JBOSS_HOME"
	else
		tar -xvzf $JBOSS_FILE
		mkdir -p $JBOSS_HOME/standalone/deployments/i2b2.war

		cd "$JBOSS_HOME/standalone/deployments/i2b2.war"
		unzip $BASE/axis/axis2.zip
		echo ""> $JBOSS_HOME/standalone/deployments/i2b2.war.dodeploy
		sed -i -e s/port-offset:0/port-offset:1010/  "$JBOSS_HOME/standalone/configuration/standalone.xml"

	fi
}

cd "$BASE"


#install postgresql
#enable permission
#create  users
#create dbs and grant permissions
#run data upload script
echo "PWD:$PWD"
echo "ANT:$ANT"


func_unzip(){

if [ -d "$BASE/i2b2webclient-1707" ]
then "echo webclient already unzipped"
else
        unzip zip_files/i2b2webclient-1707.zip

fi


if [ -d "$BASE/data" ]
then echo "found DATA FLAG"
else
mkdir "$BASE/data"
cd "$BASE/data"

unzip ../zip_files/i2b2createdb-1706.zip
cd "$BASE/data/edu.harvard.i2b2.data/Release_1-7/NewInstall/"
fi
}

ignore(){	
	local BASE="/home/ec2-user/i2b2-install"
	local BASE_CORE=$BASE/unzipped_packages/i2b2-core-server-master/
	local CONF_DATA=$BASE/data_config
	cd $BASE_CORE

	echo "PWD:$PWD"
	cd Crcdata
	mv data_build.xml build.xml
	cp $CONF_DATA/crc/db.properties db.properties

	cd ../Hivedata
	cp $CONF_DATA/hive/db.properties db.properties
	mv data_build.xml build.xml

	cd ../Imdata
	mv data_build.xml build.xml
	cp $CONF_DATA/data_config/im/db.properties db.properties

	cd ../Metadata
	mv data_build.xml build.xml
	cp $CONF_DATA/meta/db.properties db.properties

	cd ../Pmdata
	mv data_build.xml build.xml
	cp $CONF_DATA/pm/db.properties db.properties

	cd ../Workdata
	mv data_build.xml build.xml
	cp $CONF_DATA/work_place/db.properties db.properties

	exit;
}

compile_i2b2core(){
	local BASE="/home/ec2-user/i2b2-install"
	local BASE_CORE="$BASE/unzipped_packages/i2b2-core-server-master/"
	local CONF_DIR=$BASE/config
	
	local TAR_DIR="$BASE_CORE/edu.harvard.i2b2.server-common"
	cd $TAR_DIR
	echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
	ant clean dist deploy jboss_pre_deployment_setup

	echo "PWD:$PWD"

	local CELL_NAME="pm"
	local TAR_DIR="$BASE_CORE/edu.harvard.i2b2.${CELL_NAME}"
	cd $TAR_DIR
	echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
	cp -rv "$CONF_DIR/$CELL_NAME"/etc-jboss/* etc/jboss/
	ant -f master_build.xml clean build-all deploy

	#etc/jboss/*-ds.xml dataSourceconfig files are finally placed into deployment dir
	#etc/spring/*.properties file finally go into $JBOSS_HOME/standalone/configuration/*/ 
	
	#default ontology.properties is used
	#ontology_application_directory.properties is appended : edu.harvard.i2b2.ontology.applicationdir=/YOUR_JBOSS_HOME_DIR/standalone/configuration/ontologyapp
	#JBOSS home is appended to build.properties
	#data source config files is copied
	CELL_NAME="ontology"
	TAR_DIR="$BASE_CORE/edu.harvard.i2b2.${CELL_NAME}"
	cd $TAR_DIR
	echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
	echo "edu.harvard.i2b2.ontology.applicationdir=$JBOSS_HOME/standalone/configuration/ontologyapp" >> "$TAR_DIR/etc/spring/ontology_application_directory.properties"
	cp -rv "$CONF_DIR/$CELL_NAME"/etc-jboss/* etc/jboss/
	ant -f master_build.xml clean build-all deploy


	#default /etc/spring/crc.properties is used
	#crc_application_directory.properties is appended : edu.harvard.i2b2.crc.applicationdir=/YOUR_JBOSS_HOME_DIR/standalone/configuration/crcapp
	#JBOSS home is appended to build.properties
	#data source config files is copied
	export CELL_NAME="crc"
	export TAR_DIR="$BASE_CORE/edu.harvard.i2b2.${CELL_NAME}"
	cd $TAR_DIR
	echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
	cp -rv "$CONF_DIR/$CELL_NAME"/etc-jboss/* etc/jboss/
	echo "edu.harvard.i2b2.crc.applicationdir=$JBOSS_HOME/standalone/configuration/crcapp" >> "$TAR_DIR/etc/spring/crc_application_directory.properties"
	ant -f master_build.xml clean build-all deploy

	#default /etc/spring/workplace.properties is used
	#workplace_application_directory.properties is appended : edu.harvard.i2b2.workplace.applicationdir=/YOUR_JBOSS_HOME_DIR/standalone/configuration/workplaceapp
	#JBOSS home is appended to build.properties
	#data source config files is copied
	export CELL_NAME="workplace"
	export TAR_DIR="$BASE_CORE/edu.harvard.i2b2.${CELL_NAME}"
	cd $TAR_DIR
	echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
	cp -rv "$CONF_DIR/$CELL_NAME"/etc-jboss/* etc/jboss/
	echo "edu.harvard.i2b2.workplace.applicationdir=$JBOSS_HOME/standalone/configuration/workplaceapp" >> "$TAR_DIR/etc/spring/workplace_application_directory.properties"
	ant -f master_build.xml clean build-all deploy


}
run_wildfly(){

	cd $JBOSS_HOME
	sh $JBOSS_HOME/bin/standalone.sh
}


#install_java
#install_ant
#download_axis_jar
#download_wildfly
install_wildfly
compile_i2b2core
#run_wildfly

#change path to cells in the hive after logging in as admin
