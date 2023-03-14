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
#  DIRECTORY PERMISSIONS                            #
#####################################################

# Adjusting directory permissions
sudo mkdir -p /var/lib/notus
sudo mkdir -p /run/gvmd
sudo mkdir -p /run/ospd
sudo mkdir -p /run/notus-scanner      

sudo chown -R gvm:gvm /var/lib/gvm
sudo chown -R gvm:gvm /var/lib/openvas
sudo chown -R gvm:gvm /var/lib/notus
sudo chown -R gvm:gvm /var/log/gvm
sudo chown -R gvm:gvm /run/gvmd

# sudo chown -R gvm:gvm /run/ospd
# sudo chown -R gvm:gvm /run/notus-scanner    
sudo chmod -R g+srw /var/lib/gvm
sudo chmod -R g+srw /var/lib/openvas
sudo chmod -R g+srw /var/log/gvm

# Adjusting gvmd permissions
sudo chown gvm:gvm /usr/local/sbin/gvmd
sudo chmod 6750 /usr/local/sbin/gvmd

# Adjusting feed sync script permissions
sudo chown gvm:gvm /usr/local/bin/greenbone-feed-sync
sudo chmod 740 /usr/local/bin/greenbone-feed-sync



