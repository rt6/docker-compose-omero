FROM ubuntu:16.04

#Open ports to other containers in Docker network
EXPOSE 443
EXPOSE 4063
EXPOSE 4064
EXPOSE 80

# Install Java and other packages
RUN apt-get update && \ 
  apt-get upgrade -y && \
  apt-get install -y \
  vim \
  software-properties-common \
  openjdk-8-jre-headless \
  unzip \
  wget \
  python-matplotlib \
  python-numpy \
  python-pip \
  python-scipy \
  python-tables \
  python-virtualenv \
  libtiff5-dev \
  libjpeg8-dev \
  zlib1g-dev \
  libfreetype6-dev \
  liblcms2-dev \
  libwebp-dev \
  tcl8.6-dev \
  tk8.6-dev

##Install and upgrade Pillow
RUN pip install --upgrade pip
RUN wget https://www.openmicroscopy.org/site/support/omero5.2/_downloads/requirements.txt
RUN pip install --upgrade -r requirements.txt

##Install Ice 3.6
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 5E6DA83306132997
RUN apt-add-repository "deb http://zeroc.com/download/apt/ubuntu`lsb_release -rs` stable main"
RUN apt-get update && \
  apt-get -y install \
  db5.3-util \
  libssl-dev \
  libbz2-dev \
  libmcpp-dev \
  libdb++-dev \
  libdb-dev \
  zeroc-ice-all-runtime \
  zeroc-ice-all-dev
RUN pip install "zeroc-ice>3.5,<3.7"

##Install Postgress 9.4
RUN apt-get -y install apt-transport-https
RUN apt-add-repository -y "deb https://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main"
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get -y install postgresql-9.4
RUN service postgresql start
RUN systemctl enable postgresql.service

################
# OMERO server
################

RUN mkdir -p /etc/omero
COPY omero.conf /etc/omero
COPY omero-setup.sh /etc/omero

## Create service user: omero
RUN useradd -b /opt -m -c "OMERO service user" -r -s /bin/bash -U omero
RUN chmod a+X ~omero
#RUN wget http://downloads.openmicroscopy.org/latest/omero5.2/server-ice36.zip -O OMERO.server-ice36.zip
#COPY OMERO.server-5.2.8-ice36-b57.zip /opt/omero/OMERO.server-5.2.8-ice36-b57.zip
#RUN chown omero:omero /opt/omero/OMERO.server-5.2.8-ice36-b57.zip
COPY omero-5.3.4-ice36.zip /opt/omero/OMERO.server-5.3.4-ice36-b57.zip
RUN chown omero:omero /opt/omero/OMERO.server-5.3.4-ice36-b57.zip

RUN chown omero:omero /etc/omero/omero.conf
RUN chown omero:omero /etc/omero/omero-setup.sh
RUN chown omero:omero /etc/omero/omero*
RUN chmod 700 /etc/omero/omero*

############
## OMERO web
############

##Install nginx
USER root
#RUN add-apt-repository ppa:nginx/stable
#RUN apt-get update && apt-get -y install nginx
RUN apt-get -y install nginx \
  supervisor

# copy ssl keys for nginx
COPY nginx-ssl/omero.key /etc/omero/omero.domain-name.com.key
COPY nginx-ssl/omero.crt /etc/omero/omero.domain-name.com.crt
COPY nginx-ssl/nginx_omero_ssl.conf /etc/nginx/sites-available/omero-web

################
# OMERO server
################

# omero startup script
COPY omero-init.d /etc/init.d/omero
RUN chmod a+x /etc/init.d/omero && \
    update-rc.d -f omero remove && \
    update-rc.d -f omero defaults 98 02

# omero web server startup script
COPY omero-web-init.d /etc/init.d/omero-web
RUN chmod a+x /etc/init.d/omero-web && \
    update-rc.d -f omero-web remove && \
    update-rc.d -f omero-web defaults 98 02

# Ubuntu 16.04 requires wrapping system v startup scripts in system d units
# omero.service requires postgresql service to be enabled
COPY omero.service /lib/systemd/system/omero.service
RUN systemctl enable postgresql.service && \
    systemctl enable omero.service

# omero-web service requires nginx and omero service to be enabled
COPY omero-web.service  /lib/systemd/system/omero-web.service
RUN systemctl enable omero-web.service

# setup daily cron job to clean up sessions
COPY omero-web-clear-sessions /etc/cron.daily/omero-web-clear-sessions
RUN chmod a+x /etc/cron.daily/omero-web-clear-sessions

COPY supervisord/omero-supervisor.conf /etc/supervisor/conf.d/omero-supervisor.conf
COPY supervisord/start_web.sh /start_web.sh
RUN chown omero:omero /start_web.sh
COPY supervisord/start_omero.sh /start_omero.sh
RUN chown omero:omero /start_omero.sh
RUN systemctl enable supervisor

COPY start.sh /start.sh
CMD ["bash","/start.sh"]

