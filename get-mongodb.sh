#!/usr/bin/env bash

# https://downloads.mongodb.com/osx/mongodb-osx-x86_64-enterprise-3.6.7.tgz
# https://downloads.mongodb.com/linux/mongodb-linux-x86_64-enterprise-ubuntu1604-3.6.7.tgz

# We always download enterprise version (TBD)

OS=${1:-"osx"}
DISTRO=${2:-""}
RELEASE=${3:-"4.0.2"}
EDITION=${4:-"Enterprise"}

# Local directory to use
LOCAL=${5:-"/usr/local/bin"}

DOWNLOAD_ENTERPRISE_URL=https://downloads.mongodb.com
DOWNLOAD_COMMUNITY_URL=https://fastdl.mongodb.org
DOWNLOAD_DEVELOPMENT_ENTERPRISE_URL=https://downloads.mongodb.com/osx/mongodb-macos-x86_64-enterprise-4.1.2.tgz
ARCH_ENTERPRISE="x86_64-enterprise"
ARCH_COMMUNITY="x86_64"
TAG_ENTERPRISE="-ent"
TAG_COMMUNITY=""

case $EDITION in
Enterprise)
    DOWNLOAD_URL=$DOWNLOAD_ENTERPRISE_URL
    ARCH=$ARCH_ENTERPRISE
    TAG=$TAG_ENTERPRISE
    ;;
Community)
    DOWNLOAD_URL=$DOWNLOAD_COMMUNITY_URL
    ARCH=$ARCH_COMMUNITY
    TAG=$TAG_COMMUNITY
    ;;
*)
    DOWNLOAD_URL=$DOWNLOAD_COMMUNITY_URL
    ARCH=$ARCH_COMMUNITY
    TAG=$TAG_COMMUNITY
    ;;
esac

case $OS in
linux)
    ;;
osx)
    ;;
*)
    echo "get-mongodb.sh OS DISTRO RELEASE EDITION LOCAL"
    exit 1
    ;;
esac

echo Downloading MongoDB $OS $DISTRO $RELEASE $EDITION

if [[ -z $DISTRO ]]; then
    TARBALL_NAME=mongodb-$OS-$ARCH-$RELEASE
else
    TARBALL_NAME=mongodb-$OS-$ARCH-$DISTRO-$RELEASE
fi

curl -O $DOWNLOAD_URL/$OS/$TARBALL_NAME.tgz
tar xzf $TARBALL_NAME.tgz
rm $TARBALL_NAME.tgz

mkdir -p $LOCAL/mongodb-$RELEASE$TAG
mv $TARBALL_NAME/bin/* $LOCAL/mongodb-$RELEASE$TAG
rm -r $TARBALL_NAME
