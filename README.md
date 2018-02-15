installs i2b2 hive and webclient on centos vm, amazon webservice and Docker  (see wiki for details)

###Quickstart

1) ssh to the aws instance

2) sudo yum -y install git wget unzip patch bzip2 screen

3)  sudo su -
 
4) cd /opt

5) mkdir git && cd git

6) git clone https://github.com/i2b2/i2b2-quickstart.git

7) cd i2b2-quickstart

8) sudo sh scripts/install/centos_first_install.sh 2>&1|tee first.log

9) Remember to use the **public/external IP_ADDRESS** of the instance in the cmd above.

10) To verify installation see: http://[ipaddress]/webclient/
