#!/usr/bin/env bash

set -x


# Setting an install prefix environment variable
export INSTALL_PREFIX=/usr/local
# Adjusting PATH for running gvmd
export PATH=$PATH:$INSTALL_PREFIX/sbin
# Choosing a source directory
export SOURCE_DIR=$HOME/source
mkdir -p $SOURCE_DIR
# Choosing a build directory
export BUILD_DIR=$HOME/build
mkdir -p $BUILD_DIR
# Choosing a temporary install directory
export INSTALL_DIR=$HOME/install
mkdir -p $INSTALL_DIR

# Setting a GVM version as environment variable
export GVM_VERSION=22.4.1


#####################################################
# REDIS DATA STORE                                  #
#####################################################

# Installing the Redis server
sudo apt install -y redis-server

# Adding configuration for running the Redis server for the scanner
sudo cp $SOURCE_DIR/openvas-scanner-$GVM_VERSION/config/redis-openvas.conf /etc/redis/
sudo chown redis:redis /etc/redis/redis-openvas.conf
echo "db_address = /run/redis-openvas/redis.sock" | sudo tee -a /etc/openvas/openvas.conf

# Start redis with openvas config
sudo systemctl start redis-server@openvas.service
# Ensure redis with openvas config is started on every system startup
sudo systemctl enable redis-server@openvas.service
# Adding the gvm user to the redis group
sudo usermod -aG redis gvm

