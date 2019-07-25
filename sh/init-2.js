
// add shards to cluster

shard1_replsetname = 'rs1';
shard2_replsetname = 'rs2';
config_replsetname = 'cs';
// hostname = getHostName();
hostname = 'mongodb-local.computer';
s_port = 27017;
d1_port = 27018;
d2_port = 27028;
c_port = 27019;

s_host = hostname + ':' + s_port;
d1_host = hostname + ':' + d1_port;
d2_host = hostname + ':' + d2_port;
c_host = hostname + ':' + c_port;

print("\nSetting up admin user and authenticating");

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

adb = db.getSiblingDB('admin');
adb.createUser(au);
adb.auth('admin', 'tester');

print("\nAdding shard \"" + shard1_replsetname + '" with members '  + d1_host);

sh.addShard(shard1_replsetname + '/' + d1_host);

print("\nAdding shard \"" + shard2_replsetname + '" with members '  + d2_host);

sh.addShard(shard2_replsetname + '/' + d2_host);

print("\nSetting up test user");

tu = {
    user: 'test',
    pwd: 'tester',
    roles: ['readWrite']
};

tdb = db.getSiblingDB('test');
tdb.createUser(tu);

print("\nCreating sharded collection \"test.foo\" and pre-splitting chunks at \"a: 50000\"");

sh.enableSharding('test');
tdb.foo.createIndex({a: 1});
sh.shardCollection('test.foo', {a: 1});
adb.runCommand( { split: 'test.foo', middle: {a: 50000} } );

print("\nAdding some data to \"test.foo\"");

for (i=30; i<50; i++) {
    tdb.foo.insert({a: i, b: 50000-i});
}

sh.status();
