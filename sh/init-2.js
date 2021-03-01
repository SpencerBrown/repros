
// add shards to cluster

// hostname = getHostName() + ":";
hostname = 'mongodb-local.computer' + ":";

s_port = 27017;
s_host = hostname + s_port;

c_replsetname = 'cs';
c_port = 27019;
c_host = hostname + c_port;
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

print("\nSetting up admin user and authenticating");

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

adb = db.getSiblingDB('admin');
adb.createUser(au);
adb.auth('admin', 'tester');

for (i = 0; i<num_shards; i++) {
    print("\nAdding shard " + shard_replsetnames[i] + " with member "  + shard_hosts[i]);
    sh.addShard(shard_replsetnames[i] + '/' + shard_hosts[i]);
}

print("\nSetting up test user");

tu = {
    user: 'test',
    pwd: 'tester',
    roles: ['readWrite']
};

tdb = db.getSiblingDB('test');
tdb.createUser(tu);

print("Setting up \"all\" user and role");

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

adb.createRole(allrole);

alluser = {
    user: "all",
    pwd: 'tester',
    roles: ['super']
};

adb.createUser(alluser);

print("\nCreating sharded collection \"test.foo\" and pre-splitting chunks at \"a: 10\"");

sh.enableSharding('test');
tdb.foo.createIndex({a: 1});
sh.shardCollection('test.foo', {a: 1});
adb.runCommand( { split: 'test.foo', middle: {a: 10} } );

print("\nAdding some data to \"test.foo\"");

for (i=1; i<20; i++) {
    tdb.foo.insert({a: i, b: 50000+i});
}

sh.status();
