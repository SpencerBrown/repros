#!/usr/bin/env bash

if [ -z "$1" ]; then
    ls -ld /usr/local/bin/mongod*
    exit
fi

cd /usr/local/bin
ln -snf mongodb-$1 mongodb
cd -
mongod --version