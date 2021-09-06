#!/usr/bin/env bash

CONFIG=${1-m}
PORT=${2-27017}

mongod -f rs/${CONFIG}1.yaml
mongod -f rs/${CONFIG}2.yaml
mongod -f rs/${CONFIG}3.yaml

mongosh --host ${CONFIG}/mongodb-local.computer --port ${PORT} --tls --tlsCAFile tls-certs/public-ca.pem --username admin --password tester --authenticationDatabase admin
