#!/usr/bin/env bash

PORT=${1:-27017}

mongo --host mongodb-local.computer:${PORT} --username admin --password tester --authenticationDatabase admin
