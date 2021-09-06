mongostat --port 27017 --host mongodb-local.computer --ssl --sslCAFile tls/root-ca.pem --sslPEMKeyFile tls/client-key-cert.pem -u admin --authenticationDatabase admin 1 <<EOF
$(cat passwordfile)
EOF