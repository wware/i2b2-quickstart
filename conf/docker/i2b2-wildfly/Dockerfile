FROM jboss/wildfly
#ADD your-awesome-app.war /opt/jboss/wildfly/standalone/deployments/
#ADD jbh/standalone/deployments/wildfly-helloworld.war /opt/jboss/wildfly/standalone/deployments/


ADD jbh/standalone/deployments/i2b2-war.tar.bz2  /opt/jboss/wildfly/standalone/deployments/
ADD jbh/standalone/deployments/* /opt/jboss/wildfly/standalone/deployments/

#ADD jbh/standalone/deployments/i2b2\.war /opt/jboss/wildfly/standalone/deployments/
ADD jbh/standalone/configuration/* /opt/jboss/wildfly/standalone/configuration/

RUN /opt/jboss/wildfly/bin/add-user.sh admin demoadmin --silent

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly


# Expose the ports we're interested in
EXPOSE 8080 9990

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
