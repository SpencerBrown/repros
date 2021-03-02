#!/bin/bash -x

echo "Start CSRS and shards"

NUM_SHARDS=2
NUM_REPLICAS=2

echo "Setting up sharded cluster with $NUM_SHARDS shards with $NUM_REPLICAS nodes each"

mkdir -p {../data/config,../data/router}
mongod -f "sh/config.yaml"

for ((I = 0; I < NUM_SHARDS; I++)); do
  for ((J = 0; J < NUM_REPLICAS; J++)); do
    mkdir -p "../data/shard$I$J"
    PORT=$((27018 + (10 * I) + J))
    sed "s/--NODE--/shard$I$J/g; s/--PORT--/$PORT/g; s/--CONFIG--/rs$I/g" "sh/config-template.yaml" >"sh/shard$I$J.yaml"
    mongod -f "sh/shard$I$J.yaml"
  done
done

mongos -f "sh/router.yaml" &   # allow it to start asynchronously

mongo --nodb sh/init.js

#mongo --host mongodb-local.computer sh/init-2.js

mongo --username admin --password tester --authenticationDatabase admin --host mongodb-local.computer:27017
