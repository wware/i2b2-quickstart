#!/bin/bash

echo ">>>running prescript"

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

/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0

exit

###############################################
#OLD
echo ">>>running prescript"
cd /opt/jboss/wildfly/standalone/deployments/;
for x in $(find -iname '*.xml');
 do 
cat $x|sed  s/localhost:5432/${DS_IP}:${DS_PORT}/ >$x
#sed -i  s/localhost:5432/${DS_IP}:${DS_PORT}/ \"$x\";
done
/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0

