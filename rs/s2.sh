#!/usr/bin/env bash

CONFIG=${1-m}
PORT=${2-27027}

mkdir -p {../data/${CONFIG}4,../data/${CONFIG}5,../data/${CONFIG}6}

sed "s/--NODE--/${CONFIG}4/g; s/--PORT--/$((PORT+0))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}4.yaml
sed "s/--NODE--/${CONFIG}5/g; s/--PORT--/$((PORT+1))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}5.yaml
sed "s/--NODE--/${CONFIG}6/g; s/--PORT--/$((PORT+2))/g; s/--CONFIG--/${CONFIG}/g" rs/config-template.yaml > rs/${CONFIG}6.yaml

mongod -f rs/${CONFIG}4.yaml
mongod -f rs/${CONFIG}5.yaml
mongod -f rs/${CONFIG}6.yaml

sed "s/--PORT--/$((PORT+0))/g; s/--CONFIG--/${CONFIG}/g" rs/init-template.js > rs/init.js

mongo --host mongodb-local.computer --port ${PORT} --ssl --sslCAFile tls-certs/public-ca.pem rs/init.js
mongo --host ${CONFIG}/mongodb-local.computer --port ${PORT} --ssl --sslCAFile tls-certs/public-ca.pem --username admin --password tester --authenticationDatabase admin
