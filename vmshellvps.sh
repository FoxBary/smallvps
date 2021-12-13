#!/usr/bin/env bash

if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# > /dev/null 2>&1
echo "正在安装基础环境..${release}"
if [ "${release}" == "centos" ]; then
    yum update
    yum -y install wget curl zip unzip screen
else
    apt update
    apt -y install wget curl zip unzip screen
fi


echo "下载脚本..${release}"

mkdir -p /opt/script/cron
wget --no-check-certificate -qO /opt/script/cron/cleanCache.sh https://github.com/FoxBary/smallvps/blob/main/cleanCache.sh
wget --no-check-certificate -qO /opt/script/cron/cleanLog.sh https://github.com/FoxBary/smallvps/blob/main/cleanLog.sh

chmod +x /opt/script/cron/cleanCache.sh
chmod +x /opt/script/cron/cleanLog.sh


crontab -l > /opt/script/cron/tmp
echo "*/3 * * * * sh /opt/script/cron/cleanCache.sh" >> /opt/script/cron/tmp
echo "*/2 * * * * sh /opt/script/cron/cleanlog.sh" >> /opt/script/cron/tmp
crontab /opt/script/cron/tmp

echo "VPS小内存清理工具设置完成！建议重启生效"


echo "作者:Vmshell INC"
echo "VPS小内存清理工具,主要针对VPS的内存不够充裕的情况下，而页面缓存和日志文件等等占用了VPS的硬盘和内存空间，我们解决如何自动清理的问题，该脚本作者:Vmshell INC是美国怀俄明注册正规企业，现注册有自有网络运营ASN号:147002，提供香港CMI大宽带和美国洛杉矶G口云计算服务，官方地址：https://vmshell.com/"
echo "TeleGram讨论:https://t.me/vmshellhk"
echo "TeleGram频道:https://t.me/vmshell"
echo "提供微信/支付宝/美国PayPal支付(3日内无条件退款)"
echo "官网订购地址:  https://vmshell.com/"
echo "企业高速网络:  https://tototel.com/"

echo ""
