#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/weather.py"

[ -f "$F" ] || { echo "NG: playground/weather.py がありません"; exit 1; }
if ! curl -s -m 10 -o /dev/null "https://api.open-meteo.com/v1/forecast?latitude=35&longitude=139&current=temperature_2m"; then
  echo "NOTE: ネットにつながらないため、確認できません。つながる場所でもう一度 /check してください"
  exit 1
fi
OUT=$(python3 "$F" 2>&1) || { echo "NG: 実行するとエラーになります:"; echo "$OUT" | tail -3; exit 1; }
echo "$OUT" | grep -q "[0-9]" || { echo "NG: 出力に数字（気温）がありません: $OUT"; exit 1; }
echo "$OUT" | grep -q "latitude" && { echo "NG: JSON 全体が出ています。気温だけを取り出して表示しましょう"; exit 1; }
[ "$(echo "$OUT" | wc -l)" -le 3 ] || { echo "NG: 出力が長すぎます。気温だけを表示しましょう"; exit 1; }
echo "OK: $OUT"
