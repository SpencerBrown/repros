// initiate standalone

// hostname = getHostName();
hostname = 'mongodb-local.computer';
port1 = 27017;
host1 = hostname + ':' + port1;

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

print("\nSetting up test users");

tu = {
    user: 'test',
    pwd: 'tester',
    roles: [
        {role: 'readWrite', db: 'test'}
    ]
};

adb = db.getSiblingDB('admin');
adb.createUser(tu);

print("\nSetting up user 'CN=Repro,OU=Client,O=MongoDB', for MongoDB X.509 client certificate authentication");

xdb = db.getSiblingDB('$external');
xdb.createUser(
    {
        user: "CN=Repro,OU=Client,O=MongoDB",
        roles: [
            {role: "root", db: "admin"},
        ]
    }
);
