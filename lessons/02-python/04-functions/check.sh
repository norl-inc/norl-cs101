#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/py/funcs.py"

[ -f "$F" ] || { echo "NG: playground/py/funcs.py がありません"; exit 1; }
cd "$ROOT/playground/py" || exit 1
python3 - <<'PY'
import importlib.util, io, contextlib, sys
spec = importlib.util.spec_from_file_location("funcs", "funcs.py")
m = importlib.util.module_from_spec(spec)
try:
    with contextlib.redirect_stdout(io.StringIO()):
        spec.loader.exec_module(m)
except Exception as e:
    print("NG: funcs.py を読み込むとエラーです: %s: %s" % (type(e).__name__, e))
    sys.exit(1)
for name in ("add_tax", "total_price"):
    if not callable(getattr(m, name, None)):
        print("NG: 関数 %s がありません" % name)
        sys.exit(1)
if m.add_tax(1000) != 1100:
    print("NG: add_tax(1000) が %r です（1100 になるはず）" % (m.add_tax(1000),))
    sys.exit(1)
items = [{"name": "a", "price": 100}, {"name": "b", "price": 200}]
if m.total_price(items) != 300:
    print("NG: total_price が %r です（300 になるはず）" % (m.total_price(items),))
    sys.exit(1)
if m.total_price([]) != 0:
    print("NG: 空のリストの合計は 0 になるはずです")
    sys.exit(1)
print("OK: add_tax と total_price が正しく動きました")
PY
