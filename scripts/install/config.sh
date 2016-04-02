PWD=$(pwd)
BASE=$PWD
#LOCAL HOME
LOCAL=$BASE/local

#CONFIGURE
JBOSS_HOME=$LOCAL/jboss-as-7.1.1.Final
JAVA_HOME=$LOCAL/jdk1.7.0_51
AXIS_HOME=$LOCAL/axis
ANT_HOME=$LOCAL/ant
##########

echo "in INSTALL FILE PWD:$PWD"

AXIS_FILE=axis2-1.6.2-war.zip
JDK_FILE=jdk-7u51-linux-x64.tar.gz
ANT_FILE=apache-ant-1.9.6-bin.tar.bz2
JBOSS_FILE=jboss-as-7.1.1.Final.tar.gz

#check if the home directories are found as specified by user, or use default dirs
[ -d $JAVA_HOME ] || JAVA_HOME=$LOCAL/jdk1.7.0_51;#$LOCAL/${JDK_FILE/\.tar\.gz/}
[ -d $JBOSS_HOME ] || JBOSS_HOME=$LOCAL/${JBOSS_FILE/\.tar\.gz/}
[ -d $ANT_HOME ] || ANT_HOME=$LOCAL/${ANT_FILE/-bin\.tar\.bz2/}
[ -d $AXIS_HOME ] || AXIS_HOME=$LOCAL/axis

alias ant=$ANT_HOME/bin/ant
alias java="$JAVA_HOME/bin/java"

export JAVA_HOME=$JAVA_HOME

echo ">>JBOSS_HOME:$JBOSS_HOME"
[ -d $BASE/packages ] || mkdir -p $BASE/packages

echo ">>>ran config"

