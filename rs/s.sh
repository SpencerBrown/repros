#!/usr/bin/env bash

CONFIG=${1-m}
PORT=${2-27017}

mkdir -p {../data/${CONFIG}1,../data/${CONFIG}2,../data/${CONFIG}3}

sed "s/--NODE--/${CONFIG}1/g; s/--PORT--/$((PORT+0))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}1.yaml
sed "s/--NODE--/${CONFIG}2/g; s/--PORT--/$((PORT+1))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}2.yaml
sed "s/--NODE--/${CONFIG}3/g; s/--PORT--/$((PORT+2))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}3.yaml

mongod -f rs/${CONFIG}1.yaml
mongod -f rs/${CONFIG}2.yaml
mongod -f rs/${CONFIG}3.yaml

sed "s/--PORT--/$((PORT+0))/g; s/--CONFIG--/${CONFIG}/g" rs/init-template.js > rs/init.js

mongo --host mongodb-local.computer --port ${PORT} --ssl --sslCAFile tls-certs/public-ca.pem rs/init.js
mongo --host ${CONFIG}/mongodb-local.computer --port ${PORT} --ssl --sslCAFile tls-certs/public-ca.pem --username admin --password tester --authenticationDatabase admin
