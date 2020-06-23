FROM centos:7

RUN yum install -y epel-release
RUN yum update -y
RUN yum install -y git wget unzip patch bzip2 screen
RUN mkdir -p /opt/git
RUN cd /opt/git; git clone https://github.com/i2b2/i2b2-quickstart.git

# Don't kick off the wildfly server right away
COPY scripts/install/centos_first_install.sh /opt/git/i2b2-quickstart/scripts/install/centos_first_install.sh

RUN cd /opt/git/i2b2-quickstart; /bin/bash scripts/install/centos_first_install.sh 2>&1|tee /first.log

EXPOSE 9090
EXPOSE 11000

WORKDIR /opt/git/i2b2-quickstart
CMD run_wildfly . ; while true; do sleep 1; done

#9) Remember to use the **public/external IP_ADDRESS** of the instance in the cmd above.
#10) To verify installation see: http://[ipaddress]/webclient/
