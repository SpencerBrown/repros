#!/usr/bin/env bash

PORT=${1:-27017}

mongosh --tls --tlsCAFile tls-certs/public-ca.pem --tlsCertificateKeyFile tls-certs/client-key-cert.pem --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin
