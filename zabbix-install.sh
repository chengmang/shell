echo "install zabbix"

rpm -ivh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-agent-5.0.0-1.el7.x86_64.rpm

echo ""> /etc/zabbix/zabbix_agentd.conf

cat > /etc/zabbix/zabbix_agentd.conf <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
ListenPort=10050
Server=20.239.163.143
ServerActive=20.239.163.143
Hostname=$(hostname)
UnsafeUserParameters=1
Include=/etc/zabbix/zabbix_agentd.d/
EOF


systemctl restart zabbix-agent.service
echo "zabbix install finish"
