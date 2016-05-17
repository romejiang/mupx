#!/bin/bash

# Is docker already installed?
set +e
haveDocker=$(docker version | grep "version")
set -e

if [ ! "$haveDocker" ]; then

  # Remove the lock

  # Required to update system
  sudo yum -y install curl

  # Install docker
  curl -fsSL https://get.docker.com/ | sh
  sleep 3
  service docker start
fi
