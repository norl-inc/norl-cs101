#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
W="$ROOT/playground/web"

for f in index.html manifest.json sw.js; do
  [ -f "$W/$f" ] || { echo "NG: playground/web/$f がありません"; exit 1; }
done
grep -q 'TODO' "$W/manifest.json" "$W/sw.js" && { echo "NG: manifest.json か sw.js に TODO が残っています"; exit 1; }

python3 - "$W" <<'PY' || exit 1
import json, os, sys
w = sys.argv[1]
try:
    m = json.load(open(os.path.join(w, "manifest.json"), encoding="utf-8"))
except Exception as e:
    print("NG: manifest.json がJSONとして読めません:", e); sys.exit(1)
for k in ("name", "short_name", "start_url", "display", "icons"):
    if not m.get(k):
        print(f"NG: manifest.json に {k} がありません"); sys.exit(1)
for ic in m["icons"]:
    if not os.path.isfile(os.path.join(w, ic.get("src", ""))):
        print("NG: アイコンのファイルが見つかりません:", ic.get("src")); sys.exit(1)
PY

grep -q 'rel="manifest"' "$W/index.html" || { echo "NG: index.html に <link rel=\"manifest\" ...> がありません"; exit 1; }
grep -q 'serviceWorker' "$W/index.html" || { echo "NG: index.html から Service Worker を登録していません"; exit 1; }
grep -q 'sw.js' "$W/index.html" || { echo "NG: index.html が sw.js を登録していません"; exit 1; }
echo "OK: PWA の部品がそろいました。スマホのホーム画面に追加できたか、先生に見せてください"
