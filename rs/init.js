
// initiate replica set

replsetname = 'm';
// hostname = getHostName();
hostname = 'mongodb-local.computer';
port1 = 27017+0;
port2 = 27017+1;
port3 = 27017+2;

host1 = hostname + ':' + port1;
host2 = hostname + ':' + port2;
host3 = hostname + ':' + port3;

print("\nInitializing replica set \"" + replsetname + '" with members '  + host1 + ',' + host2 + ',' + host3);

config = {
    _id: replsetname,
    // protocolVersion: NumberLong(0),
    // settings: {
    //   chainingAllowed: false
    // },
    members: [
        {_id: 0, host: host1},
        {_id: 1, host: host2},
        {_id: 2, host: host3}
        // {_id: 2, host: host3, arbiterOnly: true}
    ]
};
rs.initiate(config);

// wait for primary to emerge

print("\nWaiting for replica set to become healthy...");

while (true) {
    sleep(3000);
    ismast = db.isMaster();
    if (ismast.ismaster) {break;}
}

print("\nReplica set healthy, primary is " + ismast.primary);

// set up admin user and authenticate

print("\nSetting up admin user and authenticating");

au = {
    user: 'admin',
    pwd: 'tester',
    roles: ['root']
};

adb = db.getSiblingDB('admin');
adb.createUser(au);
adb.auth('admin', 'tester');

print("\nSetting up test user");

tu = {
    user: 'test',
    pwd: 'tester',
    roles: [
        {role: 'readWrite', db: 'test'}
    ]
};

adb = db.getSiblingDB('admin');
adb.createUser(tu);

print("\nSetting up user 'CN=Client,OU=Public-Client,O=MongoDB', for MongoDB X.509 client certificate authentication");

xdb = db.getSiblingDB('$external');
xdb.createUser(
    {
        user: "CN=Client,OU=Public-Client,O=MongoDB",
        roles: [
//            "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase",
            {role: "root", db: "admin"},
        ]
    }
);
