#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/playground/api"
PORT=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')

[ -f "$D/main.py" ] || { echo "NG: playground/api/main.py がありません"; exit 1; }
command -v uv >/dev/null || { echo "NOTE: uv が見つかりません。uv を入れてからもう一度 /check してください"; exit 1; }
command -v curl >/dev/null || { echo "NOTE: curl が見つかりません"; exit 1; }

LOG="$(mktemp)"
(cd "$D" && uv run uvicorn main:app --port $PORT >"$LOG" 2>&1) &
PID=$!
trap 'kill $PID 2>/dev/null; pkill -f "uvicorn main:app --port $PORT" 2>/dev/null; rm -f "$LOG"' EXIT

for _ in $(seq 1 30); do
  curl -s -o /dev/null "http://127.0.0.1:$PORT/hello" && break
  sleep 1
done

curl -s -o /dev/null "http://127.0.0.1:$PORT/hello" || {
  echo "NG: API が起動しません。main.py のエラーを確認しましょう:"; tail -5 "$LOG"; exit 1; }
OUT=$(curl -s "http://127.0.0.1:$PORT/double?n=21")
echo "$OUT" | python3 -c 'import json,sys; sys.exit(0 if json.load(sys.stdin).get("result")==42 else 1)' 2>/dev/null \
  || { echo "NG: /double?n=21 が result 42 を返しません（返ってきたもの: ${OUT}）"; exit 1; }
echo "OK: /double?n=21 が $OUT を返しました"
