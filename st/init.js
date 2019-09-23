
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
tdb = db.getSiblingDB('test');
tdb.createUser(tu);

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
