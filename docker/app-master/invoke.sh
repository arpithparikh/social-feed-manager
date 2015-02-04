#!/bin/bash
echo "Waiting for db"
python /opt/social-feed-manager/appdeps.py --wait-secs 30 --port-wait db:5432
if [ "$?" = "1" ]; then
    echo "Problem with application dependencies."
    exit 1
fi

echo "Syncing db"
/opt/social-feed-manager/sfm/manage.py syncdb --noinput

echo "Migrating db"
/opt/social-feed-manager/sfm/manage.py migrate --noinput

echo "Starting supervisord"
[ -d /var/sfm/supervisor.d ] || mkdir /var/sfm/supervisor.d && chown www-data:www-data /var/sfm/supervisor.d
/etc/init.d/supervisor start

echo "Running server"
#Not entirely sure why this is necessary, but it works.
/etc/init.d/apache2 start
/etc/init.d/apache2 stop
apachectl -DFOREGROUND
