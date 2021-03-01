#!/bin/bash -x

echo "Start CSRS and shards"

CONFIG=${1-m}

NUM_SHARDS=2
NUM_REPLICAS=1

echo "Setting up sharded cluster with $NUM_SHARDS shards with $NUM_REPLICAS nodes each"

mkdir -p {../data/config,../data/router}
mongod -f "sh/${CONFIG}config.yaml"

for ((I = 0; I < NUM_SHARDS; I++)); do
  for ((J = 0; J < NUM_REPLICAS; J++)); do
    mkdir -p "../data/shard$I$J"
    PORT=$((27018 + (10 * I) + J))
    sed "s/--NODE--/${CONFIG}shard$I$J/g; s/--PORT--/$PORT/g; s/--CONFIG--/rs$I/g" "sh/config-template.yaml" >"sh/${CONFIG}shard$I$J.yaml"
    mongod -f "sh/${CONFIG}shard$I$J.yaml"
  done
done

mongo --nodb sh/init.js

mongos -f "sh/${CONFIG}router.yaml"

mongo --host mongodb-local.computer sh/init-2.js

mongo --username admin --password tester --authenticationDatabase admin --host mongodb-local.computer:27017
