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
# GSAD                                              #
#####################################################

# Setting the GSAd version to use
export GSAD_VERSION=$GVM_VERSION

# Required dependencies for gsad
sudo apt install -y \
  libmicrohttpd-dev \
  libxml2-dev \
  libglib2.0-dev \
  libgnutls28-dev

# Downloading the gsad sources
curl -f -L https://github.com/greenbone/gsad/archive/refs/tags/v$GSAD_VERSION.tar.gz -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz
curl -f -L https://github.com/greenbone/gsad/releases/download/v$GSAD_VERSION/gsad-$GSAD_VERSION.tar.gz.asc -o $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz.asc

# Verifying the source files
gpg --verify $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz.asc $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz
tar -C $SOURCE_DIR -xvzf $SOURCE_DIR/gsad-$GSAD_VERSION.tar.gz

# Building gsad
mkdir -p $BUILD_DIR/gsad && cd $BUILD_DIR/gsad
cmake $SOURCE_DIR/gsad-$GSAD_VERSION \
  -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DSYSCONFDIR=/etc \
  -DLOCALSTATEDIR=/var \
  -DGVMD_RUN_DIR=/run/gvmd \
  -DGSAD_RUN_DIR=/run/gsad \
  -DLOGROTATE_DIR=/etc/logrotate.d
make -j$(nproc)

# Installing gsad
mkdir -p $INSTALL_DIR/gsad
make DESTDIR=$INSTALL_DIR/gsad install
sudo cp -rv $INSTALL_DIR/gsad/* /
sudo cp -rv $INSTALL_DIR/gvmd/lib/* /lib/

