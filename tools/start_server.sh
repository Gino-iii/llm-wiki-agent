#!/bin/bash
# 启动 Wiki 网站服务
# 用法: bash tools/start_server.sh [端口，默认 8080]

PORT=${1:-8080}
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PID_FILE="$REPO_ROOT/.wiki_server.pid"
LOG_FILE="$REPO_ROOT/.wiki_server.log"

cd "$REPO_ROOT"

# 检查是否已在运行
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Wiki 服务已在运行 (PID: $OLD_PID)，访问 http://$(hostname -I | awk '{print $1}'):$PORT"
        exit 0
    fi
fi

# 检查依赖
if ! python3 -c "import mkdocs" 2>/dev/null; then
    echo "正在安装 mkdocs-material..."
    pip install mkdocs mkdocs-material jieba 2>&1 | tail -5
fi

# 启动服务（后台运行，文件变更自动刷新浏览器）
nohup python3 -m mkdocs serve --dev-addr "0.0.0.0:$PORT" \
    > "$LOG_FILE" 2>&1 &

echo $! > "$PID_FILE"
sleep 2

if kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "✅ Wiki 服务已启动"
    echo "   访问地址: http://$(hostname -I | awk '{print $1}'):$PORT"
    echo "   日志文件: $LOG_FILE"
    echo "   停止服务: bash tools/stop_server.sh"
else
    echo "❌ 启动失败，查看日志: cat $LOG_FILE"
    exit 1
fi
