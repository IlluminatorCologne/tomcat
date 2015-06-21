# illuminatorcologne/tomcat:001
#
# VERSION               0.0.1

FROM ubuntu:14.04
MAINTAINER Carsten Reuter <carsten.reuter@qsc.de>

### set environment ###
ENV JAVA_MAJOR_VERSION 8
ENV JAVA_MINOR_VERSION 8u45
ENV JAVA_HOME /opt/java/current
RUN echo "export JAVA_HOME=/opt/java/current" >> /etc/profile
RUN echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile

ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.23
ENV CATALINA_HOME /opt/tomcat/current
RUN echo "export CATALINA_HOME=/opt/tomcat/current" >> /etc/profile

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

### include necessary files ###
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh

RUN chmod +x /*.sh
RUN echo 'root:admin' | chpasswd

### prerequisites ###
RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget && \
	apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

### install java ###
RUN [ ! -d /opt/java ] && mkdir /opt/java
RUN wget -q http://192.168.11.12/jdk-8u45-linux-x64.tar.gz && \
	tar zxf jdk*.tar.gz && \
	rm -rf /jdk*gz && \
	ln -s /jdk* /opt/java/current

### install tomcat ###
RUN	[ ! -d /opt/tomcat ] && mkdir /opt/tomcat
RUN wget -q http://192.168.11.12/apache-tomcat-8.0.23.tar.gz && \
	tar zxf apache-tomcat-*.tar.gz && \
	rm -rf /apa*gz && \
	ln -s /apache-tomcat* /opt/tomcat/current
	
### configure sshd ###
RUN mkdir /var/run/sshd && \
	sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

### preparing to start ###
EXPOSE 8080 22
CMD ["/run.sh"]
