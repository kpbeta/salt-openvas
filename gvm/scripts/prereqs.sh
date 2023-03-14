#!/usr/bin/env bash

set -x
set -x

#####################################################
# PREREQUISITES                                     #
#####################################################

# Creating a gvm system user and group
sudo useradd -r -M -U -G sudo -s /usr/sbin/nologin gvm
# Add current user to gvm group
sudo usermod -aG gvm $USER

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

# Installing common build dependencies
sudo apt update
sudo apt install --no-install-recommends --assume-yes \
  build-essential \
  curl \
  cmake \
  pkg-config \
  python3 \
  python3-pip \
  gnupg

# Importing the Greenbone Community Signing key
curl -f -L https://www.greenbone.net/GBCommunitySigningKey.asc -o /tmp/GBCommunitySigningKey.asc
gpg --import /tmp/GBCommunitySigningKey.asc

# Setting the trust level for the Greenbone Community Signing key
echo "8AE4BE429B60A59B311C2E739823FAA60ED1E580:6:" > /tmp/ownertrust.txt
gpg --import-ownertrust < /tmp/ownertrust.txt

# Setting a GVM version as environment variable
export GVM_VERSION=22.4.1

set +x