#!/bin/bash
# Updated 11/15/17 kmullins

if [ -e /usr/bin/docker ]; then
    echo "Docker is already installed"
    docker --version
    echo " "
else
    echo "installing docker" 
      sudo rpm --import "https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://packages.docker.com/1.13/yum/repo/main/centos/7
      sudo yum install --nogpgcheck -y docker-engine
      sudo systemctl enable docker.service
      sudo systemctl start docker.service
      echo "The installation is complete"
      docker --version
fi


if [ -e /usr/bin/docker-compose ]; then
    echo "Docker-compose is already installed"
    docker-compose --version
    echo " "
else
    echo "installing docker-compose" 
    sudo yum -y install epel-release 
    sudo yum -y install python-pip
    sudo pip install docker-compose
    docker-compose --version
fi

# Installing miscellaneous packages
    sudo yum -y install wget tar unzip zip postgresql docker
    sudo yum -y update
    echo " Done ... "




