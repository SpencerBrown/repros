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
shard1_replsetname = 'rs1';
shard2_replsetname = 'rs2';
shard3_replsetname = 'rs3';
d1_port = 27018;
d2_port = 27028;
d3_port = 27038;

d1_host = hostname + ':' + d1_port;
d2_host = hostname + ':' + d2_port;
d3_host = hostname + ':' + d3_port;

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

d1_config = {
    _id: shard1_replsetname, members: [
        {_id: 0, host: d1_host}
    ]
};

d2_config = {
    _id: shard2_replsetname, members: [
        {_id: 0, host: d2_host}
    ]
};
d3_config = {
    _id: shard3_replsetname, members: [
        {_id: 0, host: d3_host}
    ]
};

initialize_replica_set(c_replsetname, c_host, c_config);

print("\nInitializing replica set \"" + shard1_replsetname + '" with members ' + d1_host);
d1_db = new Mongo(d1_host).getDB('admin');
d1_db.runCommand({replSetInitiate: d1_config});

print("\nWaiting for replica set to become healthy...");

while (true) {
    sleep(1000);
    ismast = d1_db.isMaster();
    if (ismast.ismaster) {
        break;
    }
}

print("\nReplica set healthy, primary is " + ismast.primary);

print("\nSetting up shard local admin user");

d1_db.createUser(au);

print("\nInitializing replica set \"" + shard2_replsetname + '" with members ' + d2_host);

d2_db = new Mongo(d2_host).getDB('admin');
d2_db.runCommand({replSetInitiate: d2_config});

print("\nWaiting for replica set to become healthy...");

while (true) {
    sleep(1000);
    ismast = d2_db.isMaster();
    if (ismast.ismaster) {
        break;
    }
}

print("\nReplica set healthy, primary is " + ismast.primary);

print("\nSetting up shard local admin user");

d2_db.createUser(au);

print("\nInitializing replica set \"" + shard3_replsetname + '" with members ' + d3_host);
d3_db = new Mongo(d3_host).getDB('admin');
d3_db.runCommand({replSetInitiate: d3_config});

print("\nWaiting for replica set to become healthy...");

while (true) {
    sleep(1000);
    ismast = d3_db.isMaster();
    if (ismast.ismaster) {
        break;
    }
}

print("\nReplica set healthy, primary is " + ismast.primary);

print("\nSetting up shard local admin user");

d3_db.createUser(au);
