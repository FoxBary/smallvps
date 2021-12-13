# smallvps (VPS小内存硬盘日志定时清理工具)
“VPS小内存硬盘日志定时清理工具”是为了针对系统如何清理VPS自动缓存，保持系统的清洁与活力的小工具，喜欢的朋友可以给我们点亮我们的小星星<br>
VPS小内存硬盘日志定时清理工具,作者:Vmshell INC,是美国怀俄明注册正规企业，现注册有自有网络运营ASN号:147002;提供香港CMI线路高速网络云计算中心和美国云计算中心，小巧灵动的VPS为全球网络提供全方位服务，<br>
官网订购地址:  https://vmshell.com/;<br>
企业高速网络:  https://tototel.com/;<br>
TeleGram讨论:https://t.me/vmshellhk;<br>
TeleGram频道:https://t.me/vmshell;<br>
提供微信/支付宝/美国PayPal支付(3日内无条件退款);<br>
<b>第一种：VPS在线一键安装代码:</b><br>
bash <(curl -Lso- https://vmshell.com/adpic/vmshellvps.sh) <br>
<b>第二种手动安装说明:</b><br>
第一步：先下载两个文件放入 /opt/script/cron 文件夹<br>
cleanLog.sh和cleanCache.sh 两个文件的下载到Linux的这个目录<br>
https://github.com/FoxBary/smallvps/blob/main/cleanCache.sh<br>
https://github.com/FoxBary/smallvps/blob/main/cleanLog.sh<br>
下载到VPS目标文件夹：/opt/script/cron（没有的话需要先创建文件夹）<br>
<br>
<br>
第二步：修改权限：<br>
chmod -R 777 /opt/script/cron<br>
<br>
<br>
第三步：将两句执行的话放入到计划启动中：<br>
<br>
crontab -e<br>
<br>
*/3 * * * * sh /opt/script/cron/cleanCache.sh<br>
*/2 * * * * sh /opt/script/cron/cleanlog.sh<br>
：wq 保存退出<br>
<br>
<br>

