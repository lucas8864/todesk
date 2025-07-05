#!/bin/bash

# 设定变量
APP_NAME="ToDesk"
DESKTOP_FILE="$HOME/Desktop/todesk.desktop"
ICON_DIR="/opt/todesk/resources"
ICON_PATH="$ICON_DIR/logo.png"
EXEC_PATH="/opt/todesk/bin/ToDesk"

# 检查 ToDesk 是否安装
if [ ! -f "$EXEC_PATH" ]; then
    echo "❌ 未找到 ToDesk 可执行文件: $EXEC_PATH"
    echo "请确认已安装 ToDesk 后再运行此脚本。"
    exit 1
fi

# 创建图标目录
mkdir -p "$ICON_DIR"

# 下载 ToDesk 图标（PNG 格式）
echo "📥 下载 ToDesk 图标..."
wget -qO "$ICON_PATH" "https://www.todesk.com/favicon.ico"

# 自动将 ico 转换为 png（如你系统有 imagemagick）
if command -v convert &>/dev/null; then
    convert "$ICON_PATH" "${ICON_PATH%.ico}.png"
    ICON_PATH="${ICON_PATH%.ico}.png"
fi

# 创建 .desktop 启动器文件
echo "📝 生成桌面快捷方式: $DESKTOP_FILE"
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=$APP_NAME
Comment=ToDesk Remote Control
Exec=$EXEC_PATH
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;RemoteAccess;
StartupNotify=true
EOF

# 赋予执行权限
chmod +x "$DESKTOP_FILE"

# 可选：复制到系统应用菜单
if [ "$(id -u)" -eq 0 ]; then
    cp "$DESKTOP_FILE" /usr/share/applications/
fi

echo "✅ 已成功创建 ToDesk 桌面快捷方式！请到桌面点击运行。"
