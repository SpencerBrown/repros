#!/usr/bin/env bash

CONFIG=${1-m}
PORT=${2-27017}

mongosh --host ${CONFIG}/mongodb-local.computer --port ${PORT} --tls --tlsCAFile tls/root-ca.pem --tlsCertificateKeyFile tls/client-key-cert.pem --username admin --password tester --authenticationDatabase admin
