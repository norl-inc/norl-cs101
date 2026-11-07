#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/playground/envdemo"

[ -d "$D" ] || { echo "NG: playground/envdemo がありません"; exit 1; }
[ -f "$D/.env" ] || { echo "NG: playground/envdemo/.env がありません"; exit 1; }
grep -q '^MY_API_KEY=.' "$D/.env" || { echo "NG: .env に MY_API_KEY=... の行がありません"; exit 1; }
[ -f "$D/.gitignore" ] || { echo "NG: .gitignore がありません"; exit 1; }
(cd "$D" && git check-ignore -q .env) || { echo "NG: .env が git の管理外になっていません（.gitignore に .env と書き、git init 済みか確認）"; exit 1; }

OUT=$(cd "$D" && python3 "$ROOT/lessons/04-infra/02-env-vars/show_env.py" 2>&1) || { echo "NG: show_env.py がエラーです: $OUT"; exit 1; }

KEY=$(grep '^MY_API_KEY=' "$D/.env" | head -1 | cut -d= -f2-)
HIT=$(find "$ROOT/playground" -path '*/.git' -prune -o -type f \( -name '*.py' -o -name '*.sh' -o -name '*.js' -o -name '*.html' \) -print0 2>/dev/null | xargs -0 grep -lF -- "$KEY" 2>/dev/null | head -1)
if [ -n "$HIT" ]; then
  echo "NG: キーの値がコードの中に書かれています（$HIT）。.env だけに置きましょう"; exit 1
fi
echo "OK: $OUT"
