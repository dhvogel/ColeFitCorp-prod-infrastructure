#!/bin/bash

# refresh package lists from repositories
sudo apt-get -y update
# install docker
sudo wget -qO- https://get.docker.com/ | sh
# add user to docker group
sudo usermod -aG docker $(whoami)
# install pip
apt-get -y install python-pip
# install docker-compose
pip install docker-compose

# get the docker-compose file from s3
wget https://s3.amazonaws.com/cfcorp/docker-compose.yml
# run it
docker-compose up
