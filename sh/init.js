// initiate config and shard replica sets

function initialize_replica_set (name, host, config) {
    print("\nInitializing replica set " + name + " with member " + host);
    let rdb = new Mongo(host).getDB('admin');
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
}

// hostname = getHostName();
hostname = 'mongodb-local.computer';

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

s_port = 27017;
s_host = hostname + ':' + s_port;

c_replsetname = 'cs';
c_port = 27019;
c_host = hostname + ':' + c_port;
c_config = {
    _id: c_replsetname, members: [
        {_id: 0, host: c_host}
    ]
};

num_shards = 3;
shard_replsetnames = ['rs0', 'rs1', 'rs2'];
shard_ports = [27018, 27028, 27038];
shard_hosts = [];
shard_configs = [];
for (i=0; i<num_shards; i++) {
    shard_hosts[i] = hostname + shard_ports[i];
    shard_configs[i] = {
        _id: shard_replsetnames[i],
        members: [{_id: 0, host: shard_hosts[i]}]
    };
}

// Initiate config replica set
initialize_replica_set(c_replsetname, c_host, c_config);

// Initiate shard replica sets
for (i=0; i<num_shards; i++) {
    initialize_replica_set(shard_replsetnames[i], shard_hosts[i], shard_configs[i]);
    let adb = new Mongo(shard_hosts[i]).getDB('admin');
    adb.createUser(au);
}
