#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/py/shop.py"

[ -f "$F" ] || { echo "NG: playground/py/shop.py がありません"; exit 1; }
OUT=$(cd "$ROOT/playground/py" && python3 shop.py 2>&1) || { echo "NG: 実行するとエラーになります:"; echo "$OUT" | tail -5; exit 1; }
RESULT=$(OUT="$OUT" python3 - <<'PY'
import json, os
s = os.environ["OUT"]
try:
    data = json.loads(s)
except Exception:
    print("NG: 出力が JSON になっていません（print は json.dumps の1行だけにしよう）")
    raise SystemExit(1)
if not isinstance(data, list) or len(data) < 2:
    print("NG: 商品が2件以上入ったリストにしよう")
    raise SystemExit(1)
for d in data:
    if not isinstance(d, dict) or "name" not in d or "price" not in d:
        print("NG: どの商品にも name と price を入れよう")
        raise SystemExit(1)
print("OK: 商品 %d 件の JSON を出せています" % len(data))
PY
) || { echo "$RESULT"; exit 1; }
echo "$RESULT"
