#!/bin/bash

echo ">>>running prescript"
echo "DS_TYPE:$DS_TYPE"
echo "DS_IP:$DS_IP"
echo "DS_CRC_IP:$DS_CRC_IP"

#echo "copying datasources for particular type of db:$DSTYPE"
#cp -rv /opt/jboss/config/$DSTYPE/* /opt/jboss/wildfly/standalone/deployments/
i


cd /opt/jboss/wildfly/standalone/deployments/;

for x in $(find -iname '*.xml');
 do
        echo ">>>$x"
        echo ${DS_IP}
        y="/opt/jboss/wildfly/standalone/deployments/$x"
        ls -hla $y;
        cat $y|sed  "s/localhost:5432/$DS_IP:$DS_PORT/" >tmp
        mv tmp $y;
#sed -i  s/localhost:5432/${DS_IP}:${DS_PORT}/ \"$x\";
done


DsDIR="/configtemp/dsconfig/$DS_TYPE"
TarPrefix="/opt/jboss/wildfly/standalone/deployments/"
cat $DsDIR/crc-ds.xml| sed  "s/DS_CRC_IP:DS_CRC_PORT/$DS_CRC_IP:$DS_CRC_PORT/" | sed  "s/DS_CRC_USER/$DS_CRC_USER/" | sed  "s/DS_CRC_PASS/$DS_CRC_PASS/" > $TarPrefix/crc-ds.xml

cd /opt/jboss/wildfly/standalone/deployments/;

/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0

exit

