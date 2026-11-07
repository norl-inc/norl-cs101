#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/hello.py"

[ -f "$F" ] || { echo "NG: playground/hello.py がありません"; exit 1; }
OUT=$(python3 "$F" 2>&1) || { echo "NG: python3 で実行するとエラーになります:"; echo "$OUT"; exit 1; }
echo "$OUT" | grep -qi "hello" || { echo "NG: 出力に hello がありません: $OUT"; exit 1; }
[ -x "$F" ] || { echo "途中: python3 では動きました。次は #! と chmod +x で ./ から動かそう"; exit 1; }
OUT2=$("$F" 2>&1) || { echo "NG: ./hello.py で実行するとエラー（1行目の #! を確認）: $OUT2"; exit 1; }
echo "OK: $OUT2"
