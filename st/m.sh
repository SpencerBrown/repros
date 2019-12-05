#!/usr/bin/env bash

PORT=${1:-27017}

mongo --ssl --sslCAFile tls-certs/public-ca.pem --sslPEMKeyFile tls-certs/client-key-cert.pem --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin
