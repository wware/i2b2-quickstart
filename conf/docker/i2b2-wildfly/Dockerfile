FROM jboss/wildfly:10.0.0.Final
MAINTAINER <Kavishwar (Kavi)  Wagholikar waghsk@gmail.com>

#ADD your-awesome-app.war /opt/jboss/wildfly/standalone/deployments/
#ADD jbh/standalone/deployments/wildfly-helloworld.war /opt/jboss/wildfly/standalone/deployments/


#ADD jbh/standalone/deployments/i2b2-war.tar.bz2  /opt/jboss/wildfly/standalone/deployments/
#ADD jbh/standalone/deployments/* /opt/jboss/wildfly/standalone/deployments/

#ADD jbh/standalone/deployments/i2b2\.war /opt/jboss/wildfly/standalone/deployments/
#ADD jbh/standalone/configuration/* /opt/jboss/wildfly/standalone/configuration/

ADD jbh/standalone/deploy.tar.bz2  /opt/jboss/wildfly/standalone/
ADD jbh/standalone/config.tar.bz2  /opt/jboss/wildfly/standalone/

COPY wfconfig /opt/jboss/wildfly/standalone/configuration/

COPY prescript.sh /opt/jboss/wildfly/bin/
#RUN chmod +x /opt/jboss/wildfly/bin/prescript.sh


RUN /opt/jboss/wildfly/bin/add-user.sh admin demoadmin --silent

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly


ENV DS_IP ${DS_IP:-i2b2-pg}
ENV DS_PORT ${DS_PORT:-5432}


# Expose the ports we're interested in
EXPOSE 9090 

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
#CMD bash -C /prescript.sh  && /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 
CMD ["/bin/bash","-C","/opt/jboss/wildfly/bin/prescript.sh"]
