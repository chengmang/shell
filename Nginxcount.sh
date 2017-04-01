uthor by banban
echo "log monitor start at" `date`
ExceptionLogDir="/opt/nginx/log/nginx"
ResultDir="/opt/script/nginxlogcount/"
DAYS1=`date +%F -d "-1 days"`
DAYS=`date +%Y/%m/%d -d "-1 days"`
ResultFile="${DAYS1}.txt"
emails="chengmangmang@benlai.com"
title="bljs_nginx_imgcount_status日志"${DAYS}
ExceptionColl(){
cd $ResultDir
if  [ ! -f "$ResultFile" ];then
touch "$ResultFile"
else
echo "$ResultFile  is exiting."
fi
echo "bljs img visit count"
echo -e "pv" >${ResultDir}${ResultFile}
cat "${ExceptionLogDir}/access_log_${DAYS1}.log" |wc -l >>${ResultDir}${ResultFile}
echo -e "\n uv" >>${ResultDir}${ResultFile}
cat "${ExceptionLogDir}/access_log_${DAYS1}.log" |awk '{print $1}' |uniq -c |wc -l >>${ResultDir}${ResultFile}
echo -e "\n 500 status" >>${ResultDir}${ResultFile}
cat "${ExceptionLogDir}/access_log_${DAYS1}.log" |awk '{if ($9==500)print $0}' |wc -l >>${ResultDir}${ResultFile}
echo -e "\n 4** status" >>${ResultDir}${ResultFile}
cat "${ExceptionLogDir}/access_log_${DAYS1}.log" |awk '{if ($9==400 || $9==404)print $0}' |wc -l >>${ResultDir}${ResultFile}
echo ${ResultDir}${ResultFile}
if [ -s "$ResultFile" ];then
cat ${ResultDir}${ResultFile}|mutt $emails -s ${title}
#cat ${ResultDir}${ResultFile}|mutt $emails -c $ccemails -s ${title}
echo "mail send sucessful at" `date`
else
echo "no exception message"
fi
}
ExceptionColl

