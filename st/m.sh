#!/usr/bin/env bash

PORT=${1:-27017}

mongosh --tls --tlsCAFile tls/root-ca.pem --tlsCertificateKeyFile tls/private/client-key-cert.pem --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin
