FROM  ubuntu:18.04

MAINTAINER  Author Frederik <frederik.hagelund@gmail.dk>

RUN apt-get -y update && \
    apt-get install -y wget && \
    apt-get install -y sudo && \
    sudo -y apt-get clean

USER root

RUN mkdir -p /opt/Yellowfin

# This enables add-apt-repository for use later in the process.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# RUN apt-get -y install openjdk-8-jre-headless

# Set Oracle Java as the default Java
RUN update-java-alternatives -s java-8-oracle

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc


ENV YF_MAJOR 8.0
ENV YF_VER 8.0.0
ENV YF_BUILD 20181113

# # Download Yellowfin
RUN wget https://files.yellowfin.bi/downloads/${YF_MAJOR}/yellowfin-${YF_VER}-${YF_BUILD}-full.jar


ENV TUTORIAL_DATABASE=false
ENV DATABASE_TYPE=PostgreSQL
ENV DATABASE_HOST=postgres
ENV DATABASE_PORT=5432
ENV DATABASE_NAME=yellowfin
ENV DATABASE_ADMIN_USER=postgres
ENV DATABASE_ADMIN_PASS=postgres
ENV DATABASE_USER=yellowfin
ENV DATABASE_PASS=yellowfin


RUN echo "InstallPath=/opt/yellowfin" >> install.properties && \
    echo "InstallTutorialDatabase=${TUTORIAL_DATABASE}" >> install.properties && \
    # echo "LicenceFilePath=licence.lic" >> install.properties && \
    echo "ServicePort=7900" >> install.properties && \
    echo "DatabaseType=${PostgreSQL}" >> install.properties && \
    echo "CreateYellowfinDB=true" >> install.properties && \
    echo "CreateYellowfinDBUser=true" >> install.properties && \
    echo "DatabaseHostname=${DATABASE_HOST}" >> install.properties && \
    echo "DatabasePort=${DATABASE_PORT}" >> install.properties && \
    echo "DatabaseName=${DATABASE_NAME}" >> install.properties && \
    echo "DatabaseDBAUser=${DATABASE_ADMIN_USER}" >> install.properties && \
    echo "DatabaseDBAPassword=${DATABASE_ADMIN_PASS}" >> install.properties && \
    echo "DatabaseUser=${DATABASE_USER}" >> install.properties && \
    echo "DatabasePassword=${DATABASE_PASS}" >> install.properties


COPY start.sh .

RUN chmod +x /start.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT "./start.sh"

EXPOSE 7900





