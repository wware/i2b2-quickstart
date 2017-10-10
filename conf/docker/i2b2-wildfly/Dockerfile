FROM jboss/wildfly:10.0.0.Final
MAINTAINER <Kavishwar (Kavi)  Wagholikar waghsk@gmail.com>


ADD jbh/standalone/deploy.tar.bz2  /opt/jboss/wildfly/standalone/
ADD jbh/standalone/config.tar.bz2  /opt/jboss/wildfly/standalone/

COPY wfconfig /opt/jboss/wildfly/standalone/configuration/
COPY dsconfig /configtemp/dsconfig/

COPY prescript.sh /opt/jboss/wildfly/bin/
#RUN chmod +x /opt/jboss/wildfly/bin/prescript.sh


RUN /opt/jboss/wildfly/bin/add-user.sh admin demoadmin --silent

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly


ENV DS_IP ${DS_IP:-i2b2-pg}
ENV DS_PORT ${DS_PORT:-5432}
ENV DS_TYPE ${DS_TYPE:-pg}
ENV DS_PASS ${DS_TYPE:-demouser}

ENV DS_CRC_IP ${DS_CRC_IP:-$DS_IP}
ENV DS_CRC_PORT ${DS_CRC_PORT:-$DS_PORT}
ENV DS_CRC_USER ${DS_CRC_USER:-i2b2demodata}
ENV DS_CRC_PASS ${DS_CRC_PASS:-$DS_PASS}

ENV DS_ONT_IP ${DS_CRC_IP:-$DS_IP}
ENV DS_ONT_PORT ${DS_CRC_PORT:-$DS_PORT}
ENV DS_ONT_USER ${DS_CRC_USER:-i2b2metadata}
ENV DS_ONT_PASS ${DS_CRC_PASS:-$DS_PASS}

ENV DS_PM_IP ${DS_CRC_IP:-$DS_IP}
ENV DS_PM_PORT ${DS_CRC_PORT:-$DS_PORT}
ENV DS_PM_USER ${DS_CRC_USER:-i2b2pm}
ENV DS_PM_PASS ${DS_CRC_PASS:-$DS_PASS}

ENV DS_WD_IP ${DS_CRC_IP:-$DS_IP}
ENV DS_WD_PORT ${DS_CRC_PORT:-$DS_PORT}
ENV DS_WD_USER ${DS_CRC_USER:-i2b2metadata}
ENV DS_WD_PASS ${DS_CRC_PASS:-$DS_PASS}

ENV DS_IM_IP ${DS_CRC_IP:-$DS_IP}
ENV DS_IM_PORT ${DS_CRC_PORT:-$DS_PORT}
ENV DS_IM_USER ${DS_CRC_USER:-i2b2imdata}
ENV DS_IM_PASS ${DS_CRC_PASS:-$DS_PASS}

# Expose the ports we're interested in
EXPOSE 9090 

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
#CMD bash -C /prescript.sh  && /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 
CMD ["/bin/bash","-C","/opt/jboss/wildfly/bin/prescript.sh"]
