#!/bin/bash
IP=$1

sudo docker network create i2b2-net
sudo docker run -d  -p 5432:5432 --net i2b2-net --name i2b2-pg   i2b2/i2b2-pg:0.5
sudo docker run -d -p 8080:8080 -p 9990:9990 --net i2b2-net --name i2b2-wildfly i2b2/i2b2-wildfly:0.1
sudo docker run -d  -p 443:443 -p 80:80 --net i2b2-net --name i2b2-web i2b2/i2b2-web:0.95 /run-httpd.sh $IP

sleep 5;
sudo docker exec -it i2b2-pg bash -c "export PUBLIC_IP=$IP;sh update_pm_cell_data.sh; "

exit
