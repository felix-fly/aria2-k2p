#!/bin/sh

cd /etc/storage/aria2

# start aria2
./aria2c --enable-rpc --rpc-listen-all --check-certificate=false > /dev/null &

# start httpd on port 81
/usr/sbin/httpd -p 81 -h /etc/storage/aria2/docs

# mount nfs folder
mkdir /mnt/Download
mount -t nfs -o nolock,remount,iocharset=utf8 ===NFS_PATH=== /mnt/Download
