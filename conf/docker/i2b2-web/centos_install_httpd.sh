#!/bin/sh
#installs https on centos 7

 yum install -y httpd
 systemctl start httpd
 systemctl enable httpd
 firewall-cmd --permanent --add-port=80/tcp
 firewall-cmd --reload
#sudo cp httpd.conf /etc/httpd/conf/
#sudo cp i2b2_proxy.conf /etc/httpd/conf.d/

