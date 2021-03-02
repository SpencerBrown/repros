num_shards = 2;
num_replicas = 1;
shard_replsetname_prefix = "rs";
shard_starting_port = 27018;

function initialize_replica_set (name, config) {
    print("\nInitializing replica set " + name);
    let host1 = config.members[0].host;
    let rdb = new Mongo(host1).getDB('admin');
    rdb.runCommand({replSetInitiate: config});
    print("\nWaiting for replica set " + name + " to become healthy...");
    while (true) {
        sleep(500);
        ismast = rdb.isMaster();
        if (ismast.ismaster) {
            break;
        }
    }
    print("\nReplica set " + name + " is healthy, primary is " + ismast.primary);
    return ismast.primary;
}

// hostname = getHostName() + ":";
hostname = 'mongodb-local.computer' + ":";

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

s_port = 27017;
s_host = hostname + s_port;

// Set up CSRS
c_replsetname = 'cs';
c_port = 27019;
c_host = hostname + c_port;
c_config = {
    _id: c_replsetname, members: [
        {_id: 0, host: c_host}
    ]
};
initialize_replica_set(c_replsetname, c_config);

// Set up shards
for (i=0; i<num_shards; i++) {
    let shard_replsetname = shard_replsetname_prefix + i;
    let shard_config = {_id: shard_replsetname, members: []};
    for (j = 0; j < num_replicas; j++) {
        let shard_port = shard_starting_port + (10 * i) + j;
        shard_config.members[j] = {_id: j, host: hostname + shard_port};
    }
    let primary = initialize_replica_set(shard_replsetname, shard_config);
    let adb = new Mongo(primary).getDB('admin');
    adb.createUser(au);  // create shard local user
}
