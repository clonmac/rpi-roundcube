#! /bin/bash

# Prepare the dirs
cd /var/www

for subdir in db logs temp
do
    mkdir -p "${subdir}"
    chown www-data: "${subdir}"
done

touch logs/errors
chown www-data: logs/errors

# Configure Roundcube
cat /app/config.inc.php.template.php | /usr/local/bin/php  > /var/www/html/config/config.inc.php
chown www-data: /var/www/html/config/config.inc.php

# Update database schema if necessary
su - www-data -c 'cd /var/www/html && echo | ./bin/update.sh'

# remove older apache2.pid file
rm -f /var/run/apache2/apache2.pid

trap '/usr/sbin/apache2ctl stop' SIGTERM

# Start Apache
/usr/sbin/apache2ctl -DFOREGROUND
