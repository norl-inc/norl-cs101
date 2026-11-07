#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/py/search.py"

[ -f "$F" ] || { echo "NG: playground/py/search.py がありません（cp でコピーしよう）"; exit 1; }
cd "$ROOT/playground/py" || exit 1
OUT=$(python3 search.py 2>&1) || { echo "NG: まだ最後まで動きません:"; echo "$OUT" | tail -3; exit 1; }
echo "$OUT" | grep -q "二分探索" || { echo "NG: 二分探索の結果が出ていません"; exit 1; }
python3 - <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("search", "search.py")
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
d = list(range(0, 100, 2))
for t in (0, 50, 98):
    if m.binary_search(d, t)[0] != d.index(t):
        print("NG: binary_search で %d を探すと位置が違います" % t); sys.exit(1)
for t in (-1, 51, 99, 1000):
    if m.binary_search(d, t)[0] != -1:
        print("NG: ないはずの %d に対して -1 を返していません" % t); sys.exit(1)
big = list(range(0, 2_000_000, 2))
if m.binary_search(big, 1_999_998)[1] > 25:
    print("NG: 100万件で 25 ステップを超えています。半分に絞れていますか？"); sys.exit(1)
PY
[ $? -eq 0 ] || exit 1
echo "OK: 二分探索が正しく動きました"
echo "$OUT" | tail -3
