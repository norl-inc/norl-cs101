#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/nn.py"

[ -f "$F" ] || { echo "NG: playground/nn.py がありません（cp でコピーしましたか？）"; exit 1; }
grep -q '^TASK = "XOR"' "$F" || { echo "NG: TASK が \"XOR\" になっていません"; exit 1; }
OUT=$(python3 "$F" 2>&1) || { echo "NG: 実行でエラーになりました: $OUT"; exit 1; }
LOSS=$(echo "$OUT" | grep "最終loss" | sed 's/.*: //')
[ -n "$LOSS" ] || { echo "NG: 最終loss が出ていません"; exit 1; }
python3 -c "import sys; sys.exit(0 if float('$LOSS') < 0.05 else 1)" \
  || { echo "NG: 最終loss が $LOSS で、まだ大きいです（HIDDEN を増やしてみましょう）"; exit 1; }
echo "OK: XOR を学習できました（最終loss $LOSS）"
