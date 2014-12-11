IMPORTANT:
There is a known issue with boot2docker that results in time drifting
(https://github.com/boot2docker/boot2docker/issues/290).  This makes Twitter very
unhappy (resulting in Timestamp out of bounds errors or 404 errors).  To fix, periodically
execute: boot2docker ssh -- sudo ntpclient -s -h pool.ntp.org

Quickstart for using the SFM docker images for development:
1.  Install docker (https://docs.docker.com/installation/#installation). For OS X, use
boot2docker (https://github.com/boot2docker/osx-installer/releases/latest).
2.  Pull the images:
docker pull gwul/sfm_db
docker pull gwul/sfm_dev
Alternatively, you can build the images.  See below.
3.  Start the images:
docker run -d --name "sfm_db" gwul/sfm_db
docker run -d --name "sfm_dev" \
    -e SFM_TWITTER_DEFAULT_USERNAME=<username> \
    -e SFM_TWITTER_CONSUMER_KEY=<key> \
    -e SFM_TWITTER_CONSUMER_SECRET=<secret> \
    -e <other env variables.  See sfm-app/local_settings.py for additional settings.>
    --link sfm_db:db \
    -p <host port>:8000 \
    -v <path to your code> \
    gwul/sfm_dev
For example:
docker run -d --name "sfm_dev" \
    -e SFM_TWITTER_DEFAULT_USERNAME=jlittman_dev \
    -e SFM_TWITTER_CONSUMER_KEY=EHdoTe7ksBgflP5nUalEfhaeo \
    -e SFM_TWITTER_CONSUMER_SECRET=ZtUpemtBkf2cEmaqiy52Ddihu9FPAiLebuMOmqN0jeQtXeAlen \
    --link sfm_db:db \
    -p 8000:8000 \
    -v ~/Data/sfm/social-feed-manager:/opt/social-feed-manager \
    gwul/sfm_dev
Alternatively, use container.sh to start the images. (For dev, you will also have to copy example.env.list to env.list,
copy example.container.sh to container.sh, and update both.)

If you are using boot2docker, you will need to run boot2docker ip to get the
ip of the vm that the app is running on.  You can then connect with http://<the ip>:8000.

The SFM admin account is "sfmadmin" and password is "password".  (This can be
changed -- see local_settings.py.)

Other helpful docker commands:
* Connect to a running app container:  docker exec -it sfm_dev /bin/bash
* Run a django management command:  docker exec -t sfm_dev python /opt/social-feed-manager/sfm/manage.py <your command>
* Connect to psql on a running db container:  docker exec -it sfm_db su postgres -c psql
* Stop an app container:  docker stop sfm_app
* Delete an app container:  docker rm sfm_app
* Get running containers:  docker ps
* Get all containers:  docker ps -a
* See the logs for an app container:  docker logs sfm_app

Differences from a typical SFM deploy to be aware of:
* The postgres instance comes from the docker image (https://registry.hub.docker.com/_/postgres/),
not the postgres debian package.
* The postgres instance is not restricted in the pg-hba.conf file.  Rather, the
access to postgres is restricted at the container level.  Only linked containers
can connect to the postgres container.
* For postgres, the postgres user is used instead of an SFM user.
* VirtualEnv is not used (since python is isolated by the container).
* Everything is run as root.
* Supervisord is running.

Building containers (from docker/):
docker build -t="gwul/sfm_db" db
and
docker build -t="gwul/sfm_dev" dev