#!/usr/bin/env bash

echo 'killing mongod processes'
pkill mongod
echo 'killing mongos processes'
pkill mongos
echo 'removing data'
sleep 3
rm -rf data
