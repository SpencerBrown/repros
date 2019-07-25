#!/usr/bin/env bash

CONFIG=${1-m}

mkdir -p ../data/m
mongod -f st/${CONFIG}.yaml


mongo --host mongodb-local.computer --port 27017 st/init.js

mongo --host mongodb-local.computer --port 27017 --username admin --password tester --authenticationDatabase admin

