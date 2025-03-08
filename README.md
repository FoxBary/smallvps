登录VPS的SSH之后，执行如下代码后reboot重启服务器
第一步：创建文件夹和文件名：
mkdir -p /opt/script/cron && nano /opt/script/cron/cleanCache.sh
输入如下脚本内容之后保存退出

#!/bin/bash
#description: 清除缓存
echo "开始清除缓存"
sync;sync;sync #写入硬盘，防止数据丢失
chmod -R 777 /opt/script/cron #修改其文件的權限
chmod -R 777 /var/spool/mail #修改其郵件消息的權限
#sleep 10 #延迟10秒
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
echo "结束清除缓存"
#description: 删除30天之前的r日志文件
echo "删除30天之前的r日志文件"
find /var/log -mtime +1 -type f -name \*.log | xargs rm -f
echo "30天之前的r日志文件删除完毕"

第二步：修改权限：
chmod -R 777 /opt/script/cron
第二步：将自动执行CRON的命令放入到计划启动中：
crontab -e
*/9 * * * * sh /opt/script/cron/cleanCache.sh
保存退出，重启cron定时任务功能


或者直接使用如下命令：
# Cron Cleanup Script
一键脚本用于清理缓存和日志，支持 CentOS、Ubuntu、Debian。

## 在线安装
在SSH中运行以下命令：

bash <(curl -sL https://github.com/FoxBary/smallvps/blob/main/vmshellvps.sh)
