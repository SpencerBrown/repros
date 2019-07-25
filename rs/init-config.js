
// initiate replica set

replsetname = 'cs';
// hostname = getHostName();
hostname = 'mongodb-local.computer';
port1 = 47017;

host1 = hostname + ':' + port1;

print("\nInitializing replica set \"" + replsetname + '" with members '  + host1);

config = {
    _id: replsetname,
    // protocolVersion: NumberLong(0),
    // settings: {
    //   chainingAllowed: false
    // },
    members: [
        {_id: 0, host: host1},
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

print("\nSetting up super user");

super_role = {
    role: 'super',
    roles: [],
    privileges: [
        {
            resource: { anyResource: true },
            actions: [
              'anyAction'
            ],
        }
    ],
};

super_user = {
    user: 'super',
    pwd: 'tester',
    roles: ['super']
};

adb = db.getSiblingDB('admin');
adb.createRole(super_role);
adb.createUser(super_user);

print("\nSetting up user 'CN=Client,OU=Public,O=MongoDB', for MongoDB X.509 client certificate authentication");

xdb = db.getSiblingDB('$external');
xdb.createUser(
    {
        user: "CN=Client,OU=Public,O=MongoDB",
        roles: [
//            "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase",
            {role: "root", db: "admin"},
        ]
    }
);

sh.addShard(replsetname + '/' + host1);

