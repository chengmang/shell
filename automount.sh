#!/bin/bash
set -e
# auto fdisk
fdisk /dev/sdc << EOF
n
p
1
 
 
wq
EOF
 
#ext4
mkfs.xfs  -f /dev/sdc1
 
#mount
if [ -e /opt/ng ]; then
exit
fi
mkdir -p /opt/ng

cp -Rfp /usr/local/openresty/nginx/* /opt/ng
mount /dev/sdc1  /usr/local/openresty/nginx/
cp -Rfp /opt/ng/*  /usr/local/openresty/nginx/
/usr/local/openresty/nginx/sbin/nginx -s reload

 
#
echo '/dev/sdc1     /usr/local/openresty/nginx    ext4    defaults        0 0'  >> /etc/fstab
#mount -a