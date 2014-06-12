# JBoss
#
# VERSION 0.1
# DOCKER-VERSION 0.7.0

FROM ubuntu
# make sure the package repository is up to date
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update 

# automatically accept oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
# and install java 7 oracle jdk
RUN apt-get -y install oracle-java7-installer && apt-get clean
RUN update-alternatives --display java
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment

#Downloading and unpacking JBoss
RUN apt-get update
RUN wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz -O /tmp/jboss7.tar.gz
RUN mkdir /var/lib/jboss7
RUN tar -xzf /tmp/jboss7.tar.gz -C /var/lib/jboss7 --strip-components=1
RUN rm /tmp/jboss7.tar.gz

#Set default configuration
WORKDIR /var/lib/jboss7/standalone/configuration/
RUN sed -i 's/enable-welcome-root="true"/enable-welcome-root="false"/g' standalone.xml
RUN sed -i 's/127.0.0.1/0.0.0.0/g' standalone.xml

#open default jboss port
EXPOSE 8080
