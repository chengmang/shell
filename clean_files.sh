#!/bin/bash
### clean logs 
clean_file()
{
echo "clean files"
cd /usr/local/openresty/nginx
/bin/rm -f logs/*gz
/bin/rm -f logs/*.log-*
echo "" > logs/error.log
### clean tmp files
sleep 3
/bin/rm -rf proxy_temp/*
### clean cache
cache_dir=`grep proxy_cache_path  conf/nginx.conf |awk '{print $2}'`
echo $cache_dir
cd $cache_dir
/bin/rm -rf *
echo "clean finishd"
#### reload nginx
/usr/local/openresty/nginx/sbin/nginx -s reload
}

use=`df -h |awk 'NR>1 {if ($6=="/") print $5}'|awk -F '%' '{print $1}' `
if [[ $use -gt 90 ]]; then
   clean_file
else
	echo "it is ok"
fi
