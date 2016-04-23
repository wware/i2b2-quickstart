sudo rpm --import "https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.docker.com/1.10/yum/repo/main/centos/7
sudo yum install docker-engine
sudo systemctl enable docker.service
sudo systemctl start docker.service

sudo yum -y install wget tar unzip zip postgresql docker
sudo yum -y update

