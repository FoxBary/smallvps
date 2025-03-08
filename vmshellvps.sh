#!/bin/bash

# 一键脚本：安装基础组件并配置清理缓存和日志的定时任务
# 支持 CentOS / Ubuntu / Debian
# 当前日期: 2025-03-08
# 作者: Grok 3 (xAI)

# 检查是否以root用户运行
if [ "$EUID" -ne 0 ]; then
    echo "错误：请以root用户运行此脚本: sudo $0"
    exit 1
fi

# 检测操作系统
if [ -f /etc/redhat-release ]; then
    OS="CentOS"
    PKG_MANAGER="yum"
    SERVICE_MANAGER="systemctl"
elif [ -f /etc/debian_version ]; then
    OS=$(cat /etc/os-release | grep -w "ID" | cut -d'=' -f2 | tr -d '"')
    PKG_MANAGER="apt"
    SERVICE_MANAGER="systemctl"
else
    echo "错误：不支持的操作系统"
    exit 1
fi

# 检查网络连接
if ! ping -c 1 google.com &> /dev/null; then
    echo "错误：网络连接失败，请检查网络设置"
    exit 1
fi

# 显示开始信息
echo "====================================="
echo "开始执行 VPS 清理脚本安装..."
echo "支持系统: CentOS / Ubuntu / Debian"
echo "====================================="

# 更新系统包
echo "更新系统软件包..."
if [ "$PKG_MANAGER" = "yum" ]; then
    yum update -y || { echo "错误：更新失败"; exit 1; }
elif [ "$PKG_MANAGER" = "apt" ]; then
    apt update -y && apt upgrade -y || { echo "错误：更新失败"; exit 1; }
fi

# 安装必要组件
echo "安装基础组件..."
if [ "$OS" = "CentOS" ]; then
    yum install -y curl vim wget nano screen unzip zip crontabs || { echo "错误：组件安装失败"; exit 1; }
    $SERVICE_MANAGER enable crond
    $SERVICE_MANAGER start crond
elif [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ]; then
    apt install -y curl vim wget nano screen unzip zip cron || { echo "错误：组件安装失败"; exit 1; }
    $SERVICE_MANAGER enable cron
    $SERVICE_MANAGER start cron
fi

# 创建文件夹和脚本文件
echo "创建清理脚本..."
mkdir -p /opt/script/cron || { echo "错误：创建目录失败"; exit 1; }
cat > /opt/script/cron/cleanCache.sh << 'EOF'
#!/bin/bash
#description: 清除缓存
echo "开始清除缓存"
sync;sync;sync #写入硬盘，防止数据丢失
chmod -R 755 /opt/script/cron #修改文件权限为755（更安全）
chmod -R 755 /var/spool/mail #修改邮件消息权限为755（更安全）
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
echo "结束清除缓存"
#description: 删除30天之前的日志文件
echo "删除30天之前的日志文件"
find /var/log -mtime +30 -type f -name "*.log" | xargs rm -f
echo "30天之前的日志文件删除完毕"
EOF

# 修改权限
echo "设置脚本权限..."
chmod -R 755 /opt/script/cron || { echo "错误：权限设置失败"; exit 1; }

# 配置定时任务
echo "配置定时任务（每9分钟运行一次）..."
(crontab -l 2>/dev/null; echo "*/9 * * * * sh /opt/script/cron/cleanCache.sh") | crontab - || { echo "错误：定时任务配置失败"; exit 1; }

# 重启cron服务
echo "重启cron服务..."
if [ "$OS" = "CentOS" ]; then
    $SERVICE_MANAGER restart crond || { echo "错误：cron服务重启失败"; exit 1; }
elif [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ]; then
    $SERVICE_MANAGER restart cron || { echo "错误：cron服务重启失败"; exit 1; }
fi

# 显示完成信息
echo "====================================="
echo "脚本执行完毕！"
echo "定时任务已设置，每9分钟运行一次 /opt/script/cron/cleanCache.sh"
echo "====================================="

# 显示广告内容
echo ""
echo "================ 广告 ================"
echo "“VPS小内存硬盘日志定时清理工具”是为了针对系统如何清理VPS自动缓存，保持系统的清洁与活力的小工具，喜欢的朋友可以给我们点亮我们的小星星"
echo ""
echo "VPS小内存硬盘日志定时清理工具, 作者: Vmshell INC, 是美国怀俄明注册正规企业，现注册有自有网络运营ASN号: 147002;"
echo "提供香港CMI线路高速网络云计算中心和美国云计算中心，小巧灵动的VPS为全球网络提供全方位服务，"
echo "官网订购地址: https://vmshell.com/;"
echo "企业高速网络: https://tototel.com/;"
echo "TeleGram讨论: https://t.me/vmshellhk;"
echo "TeleGram频道: https://t.me/vmshell;"
echo "提供微信/支付宝/美国PayPal/USDT/比特币/支付(3日内无条件退款);"
echo "====================================="

# 交互式重启提示（红色和绿色搭配）
echo ""
echo -e "请现在确认重启服务器? [\e[31myes\e[0m/\e[32mno\e[0m]"
read -p "输入你的选择: " choice

case "$choice" in
    [Yy][Ee][Ss]|[Yy])
        echo "正在重启服务器..."
        reboot
        ;;
    [Nn][Oo]|[Nn])
        echo "已取消重启，脚本执行结束。"
        ;;
    *)
        echo "无效输入，默认不重启。"
        ;;
esac
