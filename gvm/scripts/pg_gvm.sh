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
# PG-GVM                                            #
#####################################################

# Setting the pg-gvm version to use
export PG_GVM_VERSION=22.4.0

# Required dependencies for pg-gvm
sudo apt install -y \
  libglib2.0-dev \
  postgresql-server-dev-13 \
  libical-dev

# Downloading the pg-gvm sources
curl -f -L https://github.com/greenbone/pg-gvm/archive/refs/tags/v$PG_GVM_VERSION.tar.gz -o $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz
curl -f -L https://github.com/greenbone/pg-gvm/releases/download/v$PG_GVM_VERSION/pg-gvm-$PG_GVM_VERSION.tar.gz.asc -o $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz.asc

# Verifying the source file
gpg --verify $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz.asc $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz
tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION.tar.gz
# Building pg-gvm
mkdir -p $BUILD_DIR/pg-gvm && cd $BUILD_DIR/pg-gvm
cmake $SOURCE_DIR/pg-gvm-$PG_GVM_VERSION \
  -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Installing pg-gvm
mkdir -p $INSTALL_DIR/pg-gvm
make DESTDIR=$INSTALL_DIR/pg-gvm install
sudo cp -rv $INSTALL_DIR/pg-gvm/* /


