mkdir -p /home/mtproxy && \
cd /home/mtproxy && \
curl -s -o mtproxy.sh https://raw.githubusercontent.com/ellermister/mtproxy/master/mtproxy.sh && \
chmod +x mtproxy.sh && \
bash mtproxy.sh && \
echo "@reboot root bash /home/mtproxy/mtproxy.sh start" >> /etc/crontab && \
echo "MtProxy 已安装并设置为开机自动启动"
