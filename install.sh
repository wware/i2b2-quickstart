
export AXIS_FILE=axis2-1.6.2-war.zip
export JDK_FILE=jdk-7u51-linux-x64.tar.gz
export ANT_FILE=apache-ant-1.9.6-bin.tar.bz2

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
#install postgresql
#enable permission
#create  users
#create dbs and grant permissions
#run data upload script
sh data_script.sh

