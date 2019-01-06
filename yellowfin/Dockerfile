FROM  ubuntu:18.04

MAINTAINER  Author Viteco <info@viteco.dk>

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y gnupg && \
    apt-get install -y wget && \
    apt-get -y install sudo && \
    sudo apt-get clean



USER root

RUN mkdir -p /opt/Yellowfin

# This enables add-apt-repository for use later in the process.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common

ENV JAVA_VER 8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
    apt-get update && \
    echo oracle-java${JAVA_VER}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default && \
    apt-get clean && \
    rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer


# Set Oracle Java as the default Java
RUN update-java-alternatives -s java-8-oracle

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc


ENV YF_VER 8.0
ENV YF_MINOR_VER 8.0.0
ENV YF_BUILD 20181113

# # Download Yellowfin
RUN wget https://files.yellowfin.bi/downloads/${YF_VER}/yellowfin-${YF_MINOR_VER}-${YF_BUILD}-full.jar

RUN echo "InstallPath=/opt/yellowfin" >> install.properties && \
    echo "InstallTutorialDatabase=false" >> install.properties && \
    # echo "LicenceFilePath=licence.lic" >> install.properties && \
    echo "ServicePort=7900" >> install.properties && \
    echo "DatabaseType=PostgreSQL" >> install.properties && \
    echo "CreateYellowfinDB=true" >> install.properties && \
    echo "CreateYellowfinDBUser=true" >> install.properties && \
    echo "DatabaseHostname=postgres" >> install.properties && \
    echo "DatabasePort=5432" >> install.properties && \
    echo "DatabaseName=yellowfin" >> install.properties && \
    echo "DatabaseDBAUser=postgres" >> install.properties && \
    echo "DatabaseDBAPassword=postgres" >> install.properties && \
    echo "DatabaseUser=yellowfin" >> install.properties && \
    echo "DatabasePassword=yellowfin" >> install.properties


COPY start.sh .

RUN chmod +x /start.sh

ENTRYPOINT "./start.sh"

EXPOSE 7900





