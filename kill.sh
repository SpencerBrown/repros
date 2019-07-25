#!/usr/bin/env bash

echo 'killing mongod processes'
killall mongod
echo 'killing mongos processes'
killall mongos
echo 'removing data'
sleep 3
rm -rf ../data
