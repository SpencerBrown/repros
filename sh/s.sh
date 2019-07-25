#!/usr/bin/env bash

CONFIG=${1-m}

mkdir -p {data/shard1,data/shard2,data/config,data/router}

sed 's/shard1/shard2/g; s/27018/27028/g; s/rs1/rs2/g' sh/${CONFIG}shard1.yaml > sh/${CONFIG}shard2.yaml

mongod -f sh/${CONFIG}config.yaml
mongod -f sh/${CONFIG}shard1.yaml
mongod -f sh/${CONFIG}shard2.yaml

mongo --nodb sh/init.js

mongos -f sh/${CONFIG}router.yaml

mongo sh/init-2.js

mongo --username admin --password tester --authenticationDatabase admin --host mongodb-local.computer:27017
