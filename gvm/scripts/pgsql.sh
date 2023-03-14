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
#  POSTGRESQL                                       #
#####################################################

# Installing the PostgreSQL server
sudo apt install -y postgresql
# Starting the PostgreSQL database server
sudo systemctl start postgresql@13-main

# Setting up PostgreSQL user and database for the Greenbone Community Edition
su - postgres  -c 'createuser -DRS gvm'
su - postgres  -c 'createdb -O gvm gvmd'
# Setting up database permissions and extensions
su - postgres  -c 'psql gvmd -c "create role dba with superuser noinherit; grant dba to gvm;"'

