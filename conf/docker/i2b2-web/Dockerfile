#adpted from https://raw.githubusercontent.com/CentOS/CentOS-Dockerfiles/master/httpd/centos7/Dockerfile
FROM centos:centos7
MAINTAINER <Kavishwar (Kavi)  Wagholikar>

RUN yum -y update && yum clean all
RUN yum -y install httpd mod_ssl php && yum clean all

EXPOSE 80 443

# Simple startup script to avoid some issues observed with container restart 
ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh


ADD ./i2b2_proxy.conf /etc/httpd/conf.d/i2b2_proxy.conf
ADD ./webclient /var/www/html/webclient/
ADD ./admin /var/www/html/admin/

#ADD ../../httpd/i2b2_proxy.conf /etc/httpd/conf.d/i2b2_proxy.conf
#ADD ../../../unzipped_packages/webclient /var/www/html/webclient/
#ADD ../../../unzipped_packages/admin /var/www/html/admin/

COPY prescript.sh /
RUN chmod -v +x /prescript.sh

CMD ["/run-httpd.sh"]
