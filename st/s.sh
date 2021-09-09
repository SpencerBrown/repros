#!/usr/bin/env bash

CONFIG=${1-m}

mkdir -p ../data/m
mongod -f st/${CONFIG}.yaml

mongosh --tls --tlsCAFile tls/root-ca.pem --tlsCertificateKeyFile=tls/private/client-key-cert.pem  --host mongodb-local.computer --port 27017 st/init.js

mongosh --tls --tlsCAFile tls/root-ca.pem --tlsCertificateKeyFile=tls/private/client-key-cert.pem --host mongodb-local.computer --port 27017 --username admin --password tester --authenticationDatabase admin
