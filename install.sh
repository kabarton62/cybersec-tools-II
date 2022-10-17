#!/bin/bash

# Install nmap, net-tools, bridge-utils, docker, docker-compose and containerlab on Ubuntu

# Install prerequisites
sudo apt install apt-transport-https ca-certificates bridge-utils
sudo apt install -y curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y \
  docker-ce \
  nmap \
  net-tools \
  bridge-utils \
  docker-compose

# Install containerlab
sudo bash -c "$(curl -sL https://get-clab.srlinux.dev)"
