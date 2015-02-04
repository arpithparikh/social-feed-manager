FROM ubuntu:12.04
MAINTAINER Justin Littman <justinlittman@gwu.edu>

RUN apt-get update && apt-get install -y \
    python-dev \
    libxml2-dev \
    libxslt1-dev \
    libpq-dev \
    supervisor \
    python-pip \
    apache2 \
    libapache2-mod-wsgi \
    wget \
    zip
#Upgrade pip
RUN pip install -U pip
WORKDIR /tmp
RUN wget --no-check-certificate https://github.com/gwu-libraries/social-feed-manager/archive/master.zip
RUN unzip master.zip
RUN mv social-feed-manager-master /opt/social-feed-manager
#This installs the requirements.txt.
RUN pip install -r /opt/social-feed-manager/requirements.txt
#This is used to automatically create the admin user.
RUN pip install django-finalware==0.0.2
ADD local_settings.py /opt/social-feed-manager/sfm/sfm/
ADD wsgi.py /opt/social-feed-manager/sfm/sfm/
#Enable sfm site
ADD apache.conf /etc/apache2/sites-available/sfm
RUN a2ensite sfm
#Disable pre-existing default site
RUN a2dissite 000-default
#Configure supervisor
ADD supervisord.conf /etc/supervisor/
RUN mkdir /var/log/sfm
VOLUME /var/sfm
RUN mkdir /var/sfm/supervisor.d
ADD invoke.sh /opt/
RUN chmod +x /opt/invoke.sh
#Install appdeps to allow checking for application dependencies
WORKDIR /opt/social-feed-manager
RUN wget -L --no-check-certificate https://github.com/gwu-libraries/appdeps/raw/master/appdeps.py
CMD ["/opt/invoke.sh"]
EXPOSE 80
