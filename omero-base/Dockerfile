FROM ubuntu:16.04

ENV BRANCH 5.3.3
ENV ICE 3.6

# Path variables
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list

# Install dependencies
RUN apt-get update && \ 
    apt-get upgrade -y && \
    apt-get install -y \
    unzip \
    wget \
    supervisor \
    python2.7 \
    python-pil \
    python-matplotlib \
    python-pip \
    python-numpy \
    python-tables \
    python-scipy \
    #openjdk-8-jre-headless \
    ice-services  
    python-zeroc-ice \
    mencoder 
    nano \
    postgresql-client \
    postgresql-client-common

#install packages for v5.3.3 (java 1.8)
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y \
    bc \
    software-properties-common \
    openjdk-8-jre

RUN apt-get -y install \
    unzip \
    wget \
    python-{pip,pillow,numpy,scipy,tables,virtualenv,yaml,jinja2}

RUN pip install --upgrade pip

#install packages for v5.3.3 (ice 3.6)







# Add omero user and install omego tools
RUN useradd -m omero
RUN pip install -U pip
RUN pip install -U omego

RUN mkdir $OMERO_DIR
RUN chown omero $OMERO_DIR

# Download Omero with omego
USER omero
WORKDIR $OMERO_DIR

RUN omego download --branch=$BRANCH --ice $ICE --unzipdir . -v server
RUN rm OMERO.server*zip

RUN ln -s OMERO.server-* $OMERO_HOME

USER root

