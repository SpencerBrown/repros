mongostat --port 27017 --host mongodb-local.computer --ssl --sslCAFile tls-certs/public-ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem -u admin --authenticationDatabase admin 1 <<EOF
$(cat passwordfile)
EOF