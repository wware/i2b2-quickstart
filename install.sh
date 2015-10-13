

export AXIS_FILE=axis2-1.6.2-war.zip
export JDK_FILE=jdk-7u51-linux-x64.tar.gz
export ANT_FILE=apache-ant-1.9.6-bin.tar.bz2

export PWD=$(pwd)
export BASE=$PWD
export COM_DIR="$PWD/server-common"
export  ANT="$PWD/apache-ant-1.9.6/bin/ant"
alias ant=$ANT

export  JAVA="$PWD/jdk1.7.0_51/bin/java"
export  JAVA_HOME="$PWD/jdk1.7.0_51"
alias java="$JAVA"

export JBOSS_FILE=jboss-as-7.1.1.Final.tar.gz
export  JBOSS_HOME="$PWD/jboss-as-7.1.1.Final"


if [ -f $JDK_FILE ]
then echo "FOUND $JDK_FILE" 
else
	curl --create-dirs -L --cookie "oraclelicense=accept-securebackup-cookie; gpw_e24=http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html" http://download.oracle.com/otn-pub/java/jdk/7u51-b13/$JDK_FILE -o $JDK_FILE
	tar -xvzf $JDK_FILE
fi

if [ -f $ANT_FILE ]
then echo "Found $ANT_FILE"
else
	wget http://apache.mirrors.ionfish.org//ant/binaries/$ANT_FILE
	tar -xvjf $ANT_FILE 
fi

if [ -f $AXIS_FILE ]
then echo ""
else
	wget https://www.i2b2.org/software/projects/installer/$AXIS_FILE	
fi	

if [ -f $JBOSS_FILE ]
then echo "FOUND $JBOSS_FILE"
else
	wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/$JBOSS_FILE
fi

if [ -d $JBOSS_HOME ]
then echo "FOUND $JBOSS_HOME"
else
	tar -xvzf $JBOSS_FILE
	mkdir -p $JBOSS_HOME/standalone/deployments/i2b2.war

	mkdir axis
	cd axis
	unzip ../$AXIS_FILE
	mv  axis2.war axis2.zip
	cd "$JBOSS_HOME/standalone/deployments/i2b2.war"
	unzip $BASE/axis/axis2.zip
	echo ""> $JBOSS_HOME/standalone/deployments/i2b2.war.dodeploy
fi

cd "$BASE"


#install postgresql
#enable permission
#create  users
#create dbs and grant permissions
#run data upload script
echo "PWD:$PWD"
echo "ANT:$ANT"

if [ -d "$BASE/data" ]
then echo "found DATA FLAG"
else
mkdir "$BASE/data"
cd "$BASE/data"
unzip ../zip_files/i2b2createdb-1706.zip
cd "$BASE/data/edu.harvard.i2b2.data/Release_1-7/NewInstall/"

cd Crcdata
mv data_build.xml build.xml
cp ../../../../../data_config/crc/db.properties db.properties
ant create_crcdata_tables_release_1-7
ant db_demodata_load_data

cd ../Hivedata
cp ../../../../../data_config/hive/db.properties db.properties
mv data_build.xml build.xml
ant create_hivedata_tables_release_1-7
ant db_hivedata_load_data

cd ../Imdata
mv data_build.xml build.xml
cp ../../../../../data_config/im/db.properties db.properties
ant create_imdata_tables_release_1-7
ant db_imdata_load_data

cd ../Metadata
mv data_build.xml build.xml
cp ../../../../../data_config/meta/db.properties db.properties
ant create_metadata_tables_release_1-7
ant db_metadata_load_data

cd ../Pmdata
mv data_build.xml build.xml
cp ../../../../../data_config/pm/db.properties db.properties
ant create_pmdata_tables_release_1-7
ant create_triggers_release_1-7
ant db_pmdata_load_data

cd ../Workdata
mv data_build.xml build.xml
cp ../../../../../data_config/work/db.properties db.properties
ant create_workdata_tables_release_1-7
ant db_workdata_load_data

fi

export TAR_DIR="$COM_DIR/edu.harvard.i2b2.server-common"
cd $TAR_DIR
echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
ant clean dist deploy jboss_pre_deployment_setup


export TAR_DIR="$COM_DIR/edu.harvard.i2b2.pm"
cd $TAR_DIR
echo "jboss.home=$JBOSS_HOME" >> "$TAR_DIR/build.properties"
cp "$BASE/data_config/pm/pm-ds.xml" "$TAR_DIR/etc/jboss/pm-ds.xml"
ant -f master_build.xml clean build-all deploy

cd $JBOSS_HOME
sh $JBOSS_HOME/bin/standalone.sh
