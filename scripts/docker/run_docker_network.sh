#!/bin/bash

if [ -z $1 ]
then

     if [ -f /sys/hypervisor/uuid ] && [ `head -c 3 /sys/hypervisor/uuid` == ec2 ]; then
             AWS="yes"
	     echo "You did not pass in an IP address to use for this installation."
	     echo "This instance is running on AWS which requires the external address defined and "
	     echo "passed into the program. Without defining a external IP address the script will "
	     echo "use the private IP address which will not be accessable via the internet"
	     echo " "
	     echo "Please exit and pass a P1 variable into the program via ...."
	     echo " .... run_docker_network.sh 123.456.789.123 ...." 
     else
          
             AWS="no"
	     IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1) 
	     echo " "
	     echo "You did not pass in an IP address to use for this installation."
	     echo "This instance will use the current interal address for this process which is"
	     echo "  ....  $IP  ...."
	     echo " "
	     echo "If this IP address is incorrect, Please exit and pass a P1 variable into the program via ... " 
	     echo "     .... run_docker_network.sh 123.456.789.123  ...." 
	     echo " "
    fi

    read -p "Do you want to EXIT and define an IP variable  (yes or no)" choice
    case "$choice" in
      Yes|YES|yes|y) echo "Yes I want to EXIT"
	echo " "
	echo "Exiting "
	echo " "
	exit  ;;
      No|NO|no|n)    echo "OK continuing with installation";;
      *) echo "Bad choice - Try again" ;;
    esac
else
     IP=$1
     echo " "
     echo "Using given IP: $1"
     echo " "
fi


#### Starting Installations

echo " "
echo " Creating docker Network"
echo " "

sudo  docker network create i2b2-net

echo " "
sudo docker network ls | grep i2b2


echo " "
echo " Creating Postgres container i2b2-pg "
echo " "

sudo docker run -d  -p 5432:5432 --net i2b2-net --name i2b2-pg   i2b2/i2b2-pg:0.5

echo " "
sudo docker ps -a | grep i2b2-pg


echo " "
echo " Creating Wildfly Container i2b2-wildfly "
echo " "

sudo docker run -d -p 8080:8080 -p 9990:9990 --net i2b2-net --name i2b2-wildfly i2b2/i2b2-wildfly:0.1

echo " "
sudo docker ps -a | grep i2b2-wildfly


echo " "
echo " Creating Web Container i2b2-web "
echo " "

sudo docker run -d  -p 443:443 -p 80:80 --net i2b2-net --name i2b2-web i2b2/i2b2-web:0.95 /run-httpd.sh $IP

sleep 10;

echo " "
sudo docker ps -a | grep i2b2-web


echo " "
echo " Updating i2b2 database with pm_cell_data "
echo " "

sudo docker exec -it i2b2-pg bash -c "export PUBLIC_IP=$IP;sh update_pm_cell_data.sh; "

exit
