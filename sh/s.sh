NUM_SHARDS=2
NUM_REPLICAS=3
NUM_CONFIGS=3

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

  echo "Setting up new sharded cluster with $NUM_SHARDS shards with $NUM_REPLICAS members each and CSRS with $NUM_CONFIGS members"

  mkdir -p ../data/router

  for ((J = 0; J < NUM_CONFIGS; J++)); do
    mkdir -p "../data/config$J"
    PORT=$((27107  + J))
    sed "s/--NODE--/config$J/g; s/--PORT--/$PORT/g" "sh/xconfig-template.yaml" >"sh/config$J.yaml"
    mongod -f "sh/config$J.yaml"
  done

  for ((I = 0; I < NUM_SHARDS; I++)); do
    for ((J = 0; J < NUM_REPLICAS; J++)); do
      mkdir -p "../data/shard$I$J"
      PORT=$((27018 + (10 * I) + J))
      sed "s/--NODE--/shard$I$J/g; s/--PORT--/$PORT/g; s/--CONFIG--/rs$I/g" "sh/xshard-template.yaml" >"sh/shard$I$J.yaml"
      mongod -f "sh/shard$I$J.yaml"
    done
  done

  mongos -f "sh/router.yaml" &   # allow it to start asynchronously

  mongosh --nodb sh/init.js $NUM_SHARDS $NUM_REPLICAS $NUM_CONFIGS

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
  for ((J = 0; J < NUM_REPLICAS; J++)); do
    mongod -f "sh/config$J.yaml"
  done
  for ((I = 0; I < NUM_SHARDS; I++)); do
    for ((J = 0; J < NUM_REPLICAS; J++)); do
      mongod -f "sh/shard$I$J.yaml"
    done
  done
  mongos -f "sh/router.yaml"
  exit
fi