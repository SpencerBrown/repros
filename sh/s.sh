NUM_SHARDS=2
NUM_REPLICAS=1

case $1 in
  new)
    OP="new"
    ;;
  stop)
    OP="stop"
    ;;
  start)
    OP="start"
    ;;
  *)
    echo "new, stop, or start"
    exit
    ;;
esac

if [ $OP = "new" ]; then

  echo "Setting up new sharded cluster with $NUM_SHARDS shards with $NUM_REPLICAS nodes each"

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

  mongosh --nodb sh/init.js

  mongosh --username admin --password tester --authenticationDatabase admin --host mongodb-local.computer:27017
  exit
fi

if [ $OP = "stop" ]; then
  echo "Stopping cluster"
  pkill mongod
  pkill mongos
  exit
fi

if [ $OP = "start" ]; then
  echo "Starting cluster"
  mongod -f "sh/config.yaml"
  for ((I = 0; I < NUM_SHARDS; I++)); do
    for ((J = 0; J < NUM_REPLICAS; J++)); do
      mongod -f "sh/shard$I$J.yaml"
    done
  done
  mongos -f "sh/router.yaml"
  exit
fi