#!/bin/bash
echo "Waiting for db"
python /opt/sfm-setup/appdeps.py --wait-secs 30 --port-wait db:5432 --file /opt/social-feed-manager
if [ "$?" = "1" ]; then
    echo "Problem with application dependencies."
    exit 1
fi

echo "Updating requirements"
pip install -r /opt/social-feed-manager/requirements.txt

echo "Copying config"
cp /opt/sfm-setup/local_settings.py /opt/social-feed-manager/sfm/sfm/
cp /opt/sfm-setup/wsgi.py /opt/social-feed-manager/sfm/sfm/

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
#Make sure apache has started
/etc/init.d/apache2 status
while [ "$?" != "0" ];  do
    echo "Waiting for start"
    sleep 1
    /etc/init.d/apache2 status
done
echo "Stopping server"
/etc/init.d/apache2 graceful-stop
#Make sure apache has stopped
/etc/init.d/apache2 status
while [ "$?" = "0" ];  do
    echo "Waiting for stop"
    sleep 1
    /etc/init.d/apache2 status
done
echo "Starting server again"
apachectl -DFOREGROUND
