
export AXIS_FILE=axis2-1.6.2-war.zip
export JDK_FILE=jdk-7u51-linux-x64.tar.gz
export ANT_FILE=apache-ant-1.9.6-bin.tar.bz2

export PWD=$(pwd)
export  ANT="$PWD/apache-ant-1.9.6/bin/ant"
alias ant=$ANT

export  JAVA="$PWD/jdk1.7.0_51/bin/java"
export  JAVA_HOME="$PWD/jdk1.7.0_51"
alias java="$JAVA"

export JBOSS_FILE=jboss-as-7.1.1.Final.tar.gz

export  DATA_FLAG="$PWD/data_flag"

if [ -f $AXIS_FILE ]
then echo ""
else
	wget https://www.i2b2.org/software/projects/installer/$AXIS_FILE	
	#tar -xvzf $AXIS_FILE
fi	

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


if [ -f $JBOSS_FILE ]
then echo "FOUND $JBOSS_FILE"
else
	wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/$JBOSS_FILE
	tar -xvzf $JBOSS_FILE
fi

#install postgresql
#enable permission
#create  users
#create dbs and grant permissions
#run data upload script
echo "PWD:$PWD"
echo "ANT:$ANT"

if [ -f $DATA_FLAG ]
then echo "found DATA FLAG"
else
echo ""> $DATA_FLAG

cd data/edu.harvard.i2b2.data/Release_1-7/NewInstall/

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
