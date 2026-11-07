#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/hello.sh"

[ -f "$F" ] || { echo "NG: playground/hello.sh がありません"; exit 1; }
[ -x "$F" ] || { echo "NG: hello.sh に実行権限がありません"; exit 1; }
OUT=$("$F" 2>&1) || { echo "NG: 実行するとエラーになります: $OUT"; exit 1; }
echo "$OUT" | grep -qi "hello" || { echo "NG: 出力に hello がありません: $OUT"; exit 1; }
echo "OK: $OUT"
