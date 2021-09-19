num_shards = 2;
num_replicas = 3;
num_configs = 3;
shard_replsetname_prefix = "rs";
shard_starting_port = 27018;

function initialize_replica_set(name, config) {
    print("\nInitializing replica set " + name);
    let host1 = config.members[0].host;
    // let rdb = new Mongo(host1).getDB('admin');
    let rdb = Mongo(host1).getDB('admin');
    rdb.runCommand({replSetInitiate: config});
    print("\nWaiting for replica set " + name + " to become healthy...");
    while (true) {
        sleep(0.5*1000);
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
c_starting_port = 27107;
c_string = c_replsetname + "";
c_config = {
    _id: c_replsetname, members: []
};
for (j = 0; j < num_configs; j++) {
    let c_port = c_starting_port + j;
    c_config.members[j] = {_id: j, host: hostname + c_port};
    c_string = c_string + hostname + c_port + ",";
}
initialize_replica_set(c_replsetname, c_config);

// Connect to the mongos, create admin user, authenticate as admin user
sleep(5*1000); // give the mongos a chance to finish startup
// s_mongo = new Mongo(s_host);
s_mongo = Mongo(s_host);
s_adb = s_mongo.getDB('admin');
s_adb.createUser(au);
s_adb.auth(au.user, au.pwd);

// Set up shards
for (i = 0; i < num_shards; i++) {
    let shard_replsetname = shard_replsetname_prefix + i;
    let shard_config = {_id: shard_replsetname, members: []};
    let shard_string = shard_replsetname + "/";
    for (j = 0; j < num_replicas; j++) {
        let shard_port = shard_starting_port + (10 * i) + j;
        shard_config.members[j] = {_id: j, host: hostname + shard_port};
        shard_string = shard_string + hostname + shard_port + ",";
    }
    let primary = initialize_replica_set(shard_replsetname, shard_config);
    // let adb = new Mongo(primary).getDB('admin');
    let adb = Mongo(primary).getDB('admin');
    adb.createUser(au);  // create shard local user
    s_adb.runCommand({addShard: shard_string.slice(0, -1) });
}

tu = {
    user: 'test',
    pwd: 'tester',
    roles: ['readWrite']
};

tdb = s_adb.getSiblingDB('test');
tdb.createUser(tu);

allrole = {
    role: 'super',
    roles: [],
    privileges: [
        {
            resource: {anyResource: true},
            actions: ['anyAction']
        }
    ]
};

s_adb.createRole(allrole);

alluser = {
    user: "all",
    pwd: 'tester',
    roles: ['super']
};

s_adb.createUser(alluser);

xdb = s_adb.getSiblingDB('$external');
xdb.createUser(
    {
        user: "CN=Client,OU=Public-Client,O=MongoDB",
        roles: [
            {role: "root", db: "admin"},
        ]
    }
);

// temp to exit before adding data

// exit();

print("\nCreating sharded collection \"test.foo\" and pre-splitting chunks at \"a: 10\"");

s_adb.runCommand({enableSharding: 'test'});
tdb.foo.createIndex({a: 1});
s_adb.runCommand({shardCollection: 'test.foo', key: {a: 1}});
s_adb.runCommand( { split: 'test.foo', middle: {a: 10} } );

print("\nAdding some data to \"test.foo\"");

for (i=1; i<20; i++) {
    tdb.foo.insertOne({a: i, b: 50000+i});
}
