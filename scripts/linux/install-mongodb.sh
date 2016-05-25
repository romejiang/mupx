#!/bin/bash

set -e

listen=`netstat -na|grep 27017| awk '{print $6}'`
if [ "$listen" == "LISTEN" ];
then
	echo "mongodb is exist."
   	exit
fi
# we use this data directory for the backward compatibility
# older mup uses mongodb from apt-get and they used this data directory
sudo mkdir -p /var/lib/mongodb

sudo docker pull mongo:latest
set +e
sudo docker rm -f mongodb
set -e

sudo docker run \
  -d \
  --restart=always \
  --publish=127.0.0.1:27017:27017 \
  --volume=/var/lib/mongodb:/data/db \
  --volume=/opt/mongodb/mongodb.conf:/mongodb.conf \
  --name=mongodb \
  mongo mongod -f /mongodb.conf