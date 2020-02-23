// initiate config and shard replica sets

shard1_replsetname = 'rs1';
shard2_replsetname = 'rs2';
shard3_replsetname = 'rs3';
config_replsetname = 'cs';
// hostname = getHostName();
hostname = 'mongodb-local.computer';
s_port = 27017;
d1_port = 27018;
d2_port = 27028;
d3_port = 27038;
c_port = 27019;

s_host = hostname + ':' + s_port;
d1_host = hostname + ':' + d1_port;
d2_host = hostname + ':' + d2_port;
d3_host = hostname + ':' + d3_port;
c_host = hostname + ':' + c_port;

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

print("\nInitializing config replica set \"" + config_replsetname + '" with members ' + c_host);

c_config = {
    _id: config_replsetname, members: [
        {_id: 0, host: c_host}
    ]
};

c_db = new Mongo(c_host).getDB('admin');

c_db.runCommand({replSetInitiate: c_config});

print("\nWaiting for replica set to become healthy...");

while (true) {
    sleep(1000);
    ismast = c_db.isMaster();
    if (ismast.ismaster) {
        break;
    }
}

print("\nReplica set healthy, primary is " + ismast.primary);

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
