#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/py/loop.py"

[ -f "$F" ] || { echo "NG: playground/py/loop.py がありません"; exit 1; }
grep -qE '^\s*for ' "$F" || { echo "NG: for ループがありません"; exit 1; }
grep -qE '^\s*if ' "$F" || { echo "NG: if がありません"; exit 1; }
OUT=$(cd "$ROOT/playground/py" && python3 loop.py 2>&1) || { echo "NG: 実行するとエラーになります:"; echo "$OUT" | tail -5; exit 1; }
echo "$OUT" | grep -qE '[0-9]' || { echo "NG: 数字が表示されません: $OUT"; exit 1; }
echo "OK: 出力は $(echo "$OUT" | tail -1)"
