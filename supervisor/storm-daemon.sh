#!/bin/sh
exec /sbin/setuser storm java -server \
-Dstorm.options= \
-Dstorm.local.dir=/home/storm/tmp \
-Dstorm.home=/home/storm \
-Dstorm.log.dir=/home/storm/log \
-Djava.library.path=/usr/local/lib:/opt/local/lib:/usr/lib \
-Dstorm.conf.file= \
-Djava.net.preferIPv4Stack=true  \
-cp /usr/share/apache-storm:/usr/share/apache-storm/conf:/usr/share/apache-storm/lib/* -Xmx640m \
-Dlogfile.name=%daemon%.log \
-Dlogback.configurationFile=/usr/share/apache-storm/logback/cluster.xml backtype.storm.%daemon% >> /var/log/%daemon%.log 2>&1