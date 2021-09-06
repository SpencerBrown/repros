#!/usr/bin/env bash

PORT=${1:-27017}

mongo --tls --tlsCAFile tls/root-ca.pem --tlsCertificateKeyFile tls/client-key-cert.pem --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin
