FROM ubuntu:16.04

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

RUN mkdir -p /etc/omero
COPY omero.conf /etc/omero
COPY omero-setup.sh /etc/omero

## Create service user: omero
RUN useradd -b /opt -m -c "OMERO service user" -r -s /bin/bash -U omero
RUN chmod a+X ~omero
COPY OMERO.server-5.2.8-ice36-b57.zip /opt/omero/OMERO.server-5.2.8-ice36-b57.zip
#RUN wget http://downloads.openmicroscopy.org/latest/omero5.2/server-ice36.zip -O OMERO.server-ice36.zip

RUN chown omero:omero /opt/omero/OMERO.server-5.2.8-ice36-b57.zip
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
RUN apt-get -y install nginx


COPY start.sh /start.sh
CMD ["bash","/start.sh"]
