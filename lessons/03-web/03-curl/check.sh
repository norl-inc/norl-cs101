#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/weather.json"

[ -f "$F" ] || { echo "NG: playground/weather.json がありません（curl の -o で保存しましたか？）"; exit 1; }
python3 - "$F" <<'PY' || exit 1
import json, sys
try:
    d = json.load(open(sys.argv[1]))
except Exception:
    print("NG: weather.json が JSON になっていません。中身を cat で見てみましょう"); sys.exit(1)
t = d.get("current", {}).get("temperature_2m") if isinstance(d, dict) else None
if not isinstance(t, (int, float)):
    print("NG: current の中に temperature_2m（数字）がありません。URL に current=temperature_2m を付けましたか？"); sys.exit(1)
print(f"OK: 気温 {t}℃ が保存されています")
PY
