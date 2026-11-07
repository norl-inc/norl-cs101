#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/playground/py"

command -v uv >/dev/null 2>&1 || { echo "NG: uv が見つかりません。brew install uv を試してみよう"; exit 1; }
[ -f "$D/pyproject.toml" ] || { echo "NG: playground/py/pyproject.toml がありません（uv init playground/py をやった？）"; exit 1; }
[ -f "$D/main.py" ] || { echo "NG: playground/py/main.py がありません"; exit 1; }
OUT=$(cd "$D" && uv run main.py 2>&1) || {
  echo "NG: uv run main.py がエラーになりました（初回は Python のダウンロードにネットワークが要ることがあります）:"
  echo "$OUT" | tail -5
  exit 1
}
[ -n "$OUT" ] || { echo "NG: main.py が何も表示しません"; exit 1; }
echo "OK: uv run main.py の出力: $OUT"
