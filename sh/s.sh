#!/bin/bash -x

echo "Start CSRS and shards"

CONFIG=${1-m}

NUM_SHARDS=3

mkdir -p {../data/config,../data/router}
mongod -f "sh/${CONFIG}config.yaml"

for ((I=0;I<NUM_SHARDS;I++));
do
  mkdir -p "../data/shard$I"
  if ((I > 0));
  then
    PORT=$((27018+(10*I)))
    sed "s/shard0/shard$I/g; s/27018/$PORT/g; s/rs0/rs$I/g" "sh/${CONFIG}shard0.yaml" > "sh/${CONFIG}shard$I.yaml"
  fi
  mongod -f "sh/${CONFIG}shard$I.yaml"
done

mongo --nodb sh/init.js

mongos -f "sh/${CONFIG}router.yaml"

mongo --host mongodb-local.computer sh/init-2.js

mongo --username admin --password tester --authenticationDatabase admin --host mongodb-local.computer:27017
