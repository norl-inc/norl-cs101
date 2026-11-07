#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/playground/make"
if [ ! -d "$D" ]; then
  echo "NG: playground/make/ がありません"; exit 1
fi
echo "OK: playground/make/ がある"
N=$(find "$D" -type f ! -name 'sales.csv' ! -name '.DS_Store' | wc -l | tr -d ' ')
if [ "$N" -ge 2 ]; then
  echo "OK: 作ったものが ${N} 個ある"
else
  echo "NG: sales.csv 以外のファイルが2つ以上必要です（今は ${N} 個）"; exit 1
fi
exit 0
