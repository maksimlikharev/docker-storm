# apache-storm-0.10.0
#
# VERSION      1.0

# use the ubuntu base image provided by dotCloud
FROM phusion/baseimage:0.9.18
MAINTAINER Florian HUSSONNOIS, florian.hussonnois_gmail.com

# Install Oracle JDK 8 and others useful packages
RUN apt-get update && \
apt-get upgrade -y && \
apt-get install -y python-software-properties software-properties-common && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
apt-get install -y oracle-java8-installer && \
rm -rf /var/cache/oracle-jdk8-installer && \
rm -rf /usr/lib/jvm/java-8-oracle/bin && \
rm -rf /usr/lib/jvm/java-8-oracle/include && \
rm -rf /usr/lib/jvm/java-8-oracle/man && \
rm -rf /usr/lib/jvm/java-8-oracle/db && \
rm -rf /usr/lib/jvm/java-8-oracle/lib && \
apt-get clean && \ 
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/service/* /usr/share/apache-storm/logs/* && \
find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true && \
find /usr/share/doc -empty|xargs rmdir || true && \
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* && \
rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

ENV STORM_VERSION 0.9.5

# Create storm group and user
ENV STORM_HOME /usr/share/apache-storm

RUN groupadd storm; useradd --gid storm --home-dir /home/storm --create-home --shell /bin/bash storm

# Download and Install Apache Storm
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/storm/apache-storm-$STORM_VERSION/apache-storm-$STORM_VERSION.tar.gz && \
tar -xzvf apache-storm-$STORM_VERSION.tar.gz -C /usr/share && mv $STORM_HOME-$STORM_VERSION $STORM_HOME && \
rm -rf apache-storm-$STORM_VERSION.tar.gz && \
rm -rf /usr/share/apache-storm/examples

RUN mkdir /var/log/storm ; chown -R storm:storm /var/log/storm ; ln -s /var/log/storm /home/storm/log ; mkdir -p /etc/my_init.d && \
ln -s $STORM_HOME/bin/storm /usr/bin/storm && \
mkdir -p /home/storm/tmp && \
chown -R storm:storm /home/storm

ADD conf/storm.yaml.template $STORM_HOME/conf/storm.yaml.template

ADD script/entrypoint.sh /etc/my_init.d/entrypoint.sh
ADD supervisor/storm-daemon.sh /home/storm/storm-daemon.sh

RUN chown -R storm:storm $STORM_HOME && chmod a+x /etc/my_init.d/entrypoint.sh && chmod a+x /home/storm/storm-daemon.sh

# Add VOLUMEs to allow backup of config and logs
VOLUME ["/usr/share/apache-storm/conf","/var/log/storm"]

CMD ["/sbin/my_init"]
