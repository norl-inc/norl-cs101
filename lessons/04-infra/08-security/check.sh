#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/security/hash_pw.py"

[ -f "$F" ] || { echo "NG: playground/security/hash_pw.py がありません（hash_starter.py をコピー）"; exit 1; }
python3 "$F" >/dev/null 2>&1 || { echo "NG: hash_pw.py がエラーです。最後の行を読んでみましょう: $(python3 "$F" 2>&1 | tail -1)"; exit 1; }

python3 - "$F" <<'PY'
import importlib.util, sys
spec = importlib.util.spec_from_file_location("hash_pw", sys.argv[1])
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)
try:
    a, b = m.hash_password("pw-test"), m.hash_password("pw-test")
except Exception as e:
    print("NG: hash_password が動きません:", e); sys.exit(1)
if not isinstance(a, str) or "pw-test" in a:
    print("NG: パスワードがそのまま入っています"); sys.exit(1)
if a == b:
    print("NG: 同じパスワードで同じハッシュです。塩がランダムになっていません"); sys.exit(1)
try:
    ok, ng = m.verify_password("pw-test", a), m.verify_password("wrong", a)
except Exception as e:
    print("NG: verify_password が動きません:", e); sys.exit(1)
if ok is not True:
    print("NG: 正しいパスワードを照合できません"); sys.exit(1)
if ng is not False:
    print("NG: 間違ったパスワードが通ってしまいます"); sys.exit(1)
print("OK: 塩つきハッシュで保存でき、正しいパスワードだけ照合できました")
PY
