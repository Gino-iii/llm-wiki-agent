#!/bin/bash
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PID_FILE="$REPO_ROOT/.wiki_server.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        kill "$PID"
        rm "$PID_FILE"
        echo "✅ Wiki 服务已停止"
    else
        rm "$PID_FILE"
        echo "服务未在运行"
    fi
else
    echo "服务未在运行"
fi
