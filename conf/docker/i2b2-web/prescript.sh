#!/bin/bash
echo "running prescript with arg:$1"
sed -i -e "s/localhost/$1/" /var/www/html/webclient/i2b2_config_data.js
sed -i -e "s/localhost/$1/" /var/www/html/admin/i2b2_config_data.js
sed -i -e "s/localhost/$1/" /etc/httpd/conf.d/i2b2_proxy.conf
