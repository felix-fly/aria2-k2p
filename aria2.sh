#!/bin/sh

cd /etc/storage/aria2

# start aria2
aria2c --enable-rpc --rpc-listen-all

# mount webui to www
mount --bind ./docs /www/aria2
