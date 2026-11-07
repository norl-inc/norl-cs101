#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT/lessons/07-capstone/_lib.sh"
DIR="$ROOT/playground/capstone"
S="$DIR/static"

for f in manifest.json sw.js icon.svg index.html; do
  [ -f "$S/$f" ] || cap_ng "playground/capstone/static/$f がありません（README の cp を打ちましたか？）"
done

python3 - "$S/manifest.json" <<'PY' || exit 1
import json, re, sys
try:
    m = json.load(open(sys.argv[1]))
except Exception as e:
    print("NG: manifest.json が JSON として読めません:", e); sys.exit(1)
for k in ("name", "short_name"):
    v = m.get(k, "")
    if not v.strip() or "TODO" in v:
        print(f"NG: manifest.json の {k} がまだ TODO のままです"); sys.exit(1)
if not re.fullmatch(r"#[0-9a-fA-F]{6}", m.get("theme_color", "")):
    print("NG: theme_color が #RRGGBB の形になっていません（例: #2f6fed）"); sys.exit(1)
if m.get("display") not in ("standalone", "fullscreen", "minimal-ui"):
    print("NG: display が standalone などになっていません"); sys.exit(1)
if not m.get("start_url") or not m.get("icons"):
    print("NG: start_url か icons がありません"); sys.exit(1)
PY

SW=$(cap_code "$S/sw.js")
echo "$SW" | grep -q 'caches\.open' || cap_ng "sw.js に caches.open がありません（TODO 1）"
echo "$SW" | grep -q 'addAll' || cap_ng "sw.js に addAll がありません（TODO 1: FILES をまとめて保存）"
echo "$SW" | grep -q 'respondWith' || cap_ng "sw.js に respondWith がありません（TODO 2）"
echo "$SW" | grep -q 'caches\.match' || cap_ng "sw.js に caches.match がありません（TODO 2: キャッシュを探す）"

HT=$(cap_code "$S/index.html")
echo "$HT" | grep -q 'rel="manifest"' || cap_ng "index.html の <head> に <link rel=\"manifest\" ...> がありません（README の手順3）"
echo "$HT" | grep -q 'serviceWorker' || cap_ng "index.html に navigator.serviceWorker.register がありません（README の手順3）"

grep -q StaticFiles "$DIR/main.py" || cap_ng "main.py で static を配信していません（7-2）"
cap_start "$DIR"
for p in manifest.json sw.js icon.svg; do
  c=$(curl -s -o /dev/null -w '%{http_code}' "$BASE/$p")
  [ "$c" = "200" ] || cap_ng "$BASE/$p が $c です。/$p が直下から配信されていません"
done
curl -s "$BASE/manifest.json" | python3 -c 'import sys,json; json.load(sys.stdin)' 2>/dev/null || cap_ng "配信された manifest.json が JSON ではありません"
cap_api_test
echo "OK: manifest.json と sw.js が配信され、index.html から読み込まれ、APIも生きています"
echo "    次は DevTools の Application タブで Service Worker が動いているか、自分の目で見よう"
