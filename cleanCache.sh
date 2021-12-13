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
