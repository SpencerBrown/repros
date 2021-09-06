#!/usr/bin/env bash

CONFIG=${1-m}
PORT=${2-27017}

mongo --host ${CONFIG}/mongodb-local.computer --port ${PORT} --ssl --sslCAFile tls-certs/public-ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --username admin --password tester --authenticationDatabase admin
