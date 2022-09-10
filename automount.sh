#!/bin/bash
set -e

mdev=`df -h |awk '{print $1}'  |grep '/dev/'`
device=`fdisk  -l  |grep 'Disk /dev/' |awk -F '[ :]' '{print $2}' |grep  -v swap`
echo $mdev
echo $device

fdisk  -l  |grep 'Disk /dev/' |awk -F '[ :]' '{print $2}' |grep  -v swap > /tmp/device.txt
df -h |awk '{print $1}'  |grep '/dev/' > /tmp/mdev.txt


get_disk_need_fdisk()
{

while read line
do
  echo $line
  grep  $line /tmp/mdev.txt
  if [ $? -ne 0 ]
  then
    echo $line >>/tmp/needmount.txt
  fi
done < /tmp/device.txt

}

# auto fdisk
fdisk /dev/sdc << EOF
n
p
1
 
 
wq
EOF
 
#formate ext4
mkfs.xfs  -f /dev/sdc1
 
#mount dir
if [ -e /opt/ng ]; then
exit
fi
mkdir -p /opt/ng

cp -Rfp /usr/local/openresty/nginx/* /opt/ng
mount /dev/sdc1  /usr/local/openresty/nginx/
cp -Rfp /opt/ng/*  /usr/local/openresty/nginx/
/usr/local/openresty/nginx/sbin/nginx -s reload

 
echo '/dev/sdc1     /usr/local/openresty/nginx    ext4    defaults        0 0'  >> /etc/fstab
#mount -a

# m passwd
# echo "Dd112211" | passwd --stdin root
