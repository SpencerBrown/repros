#!/usr/bin/env bash

PORT=${1:-27017}

mongosh --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin --retryWrites
