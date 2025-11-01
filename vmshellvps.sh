#!/bin/bash
# ======================================================
# Linux 一键更新 + 安装基础组件 + 自动创建定时清理缓存任务
# Author: VmShell INC
# ======================================================

echo "===== [1/6] 检测系统类型 ====="
# 识别系统包管理器
if command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    UPDATE_CMD="apt -y update && apt -y upgrade"
    INSTALL_CMD="apt -y install"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="dnf -y update"
    INSTALL_CMD="dnf -y install"
elif command -v yum >/dev/null 2>&1; then
    PKG_MANAGER="yum"
    UPDATE_CMD="yum -y update"
    INSTALL_CMD="yum -y install"
elif command -v zypper >/dev/null 2>&1; then
    PKG_MANAGER="zypper"
    UPDATE_CMD="zypper refresh && zypper update -y"
    INSTALL_CMD="zypper install -y"
else
    echo "❌ 未检测到支持的包管理器，请手动修改此脚本。"
    exit 1
fi

echo "系统使用包管理器：$PKG_MANAGER"
sleep 1

echo "===== [2/6] 执行系统更新 ====="
eval "$UPDATE_CMD"

echo "===== [3/6] 安装基础组件 ====="
$INSTALL_CMD nano zip wget curl screen unzip vim cron npm -y

echo "===== [4/6] 创建清理脚本 ====="
mkdir -p /opt/script/cron
cat > /opt/script/cron/cleanCache.sh <<'EOF'
03e786e47f606901cb7e9ec90d244ff5
#!/bin/bash
#description: 清除缓存
echo "开始清除缓存"
sync;sync;sync # 写入硬盘，防止数据丢失
chmod -R 777 /opt/script/cron # 修改脚本目录权限
chmod -R 777 /var/spool/mail # 修改邮件目录权限
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
echo "结束清除缓存"

#description: 删除30天之前的日志文件
echo "删除30天之前的日志文件"
find /var/log -mtime +30 -type f -name "*.log" -exec rm -f {} \;
echo "30天之前的日志文件删除完毕"
EOF

echo "===== [5/6] 修改权限 ====="
chmod -R 777 /opt/script/cron

echo "===== [6/6] 添加定时任务 ====="
CRON_JOB="*/9 * * * * sh /opt/script/cron/cleanCache.sh"
# 检查是否已存在该任务
crontab -l 2>/dev/null | grep -q "/opt/script/cron/cleanCache.sh"
if [ $? -ne 0 ]; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✅ 定时任务已添加：每9分钟自动清理缓存"
else
    echo "ℹ️ 定时任务已存在，跳过添加。"
fi

echo "===== ✅ 所有操作完成 ====="
echo "建议重启系统生效：reboot"
