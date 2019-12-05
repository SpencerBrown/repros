#!/usr/bin/env bash

CONFIG=${1-m}

mkdir -p ../data/m
mongod -f st/${CONFIG}.yaml

mongo --ssl --sslCAFile tls-certs/public-ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --host mongodb-local.computer --port 27017 st/init.js
mongo --ssl --sslCAFile tls-certs/public-ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --host mongodb-local.computer --port 27017 --username admin --password tester --authenticationDatabase admin

