BASE=$1
PAK=i2b2-core-server
TAG=$(curl https://api.github.com/repos/i2b2/i2b2-core-server/releases/latest | grep "tag_name"|cut -d: -f2|tr -d ",\" ")
echo $TAG
TDIR="$BASE/unzipped_packages/$PAK-master/"
HISTORY_DIR="$BASE/history"

create_dir(){
	_TDIR=$1
	if [ -d $_TDIR ]; then
		echo "found $_TDIR"
	else
		echo "creating $_TDIR"
		mkdir -p $_TDIR
	fi;
}

write_history(){
	_PAK=$1
	_TAG=$2
	echo "$_TAG">>"$HISTORY_DIR/$_PAK"
}

create_dir $TDIR;
create_dir $HISTORY_DIR;

cd $TDIR
LINK="https://github.com/i2b2/$PAK/archive/$TAG.tar.gz"
echo "downloading $LINK"
wget -O downloaded_tar $LINK && write_history $PAK $TAG
tar -xvzf downloaded_tar --strip 1
rm -rf downloaded_tar
