#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/ai/agent.py"
. "$(dirname "$0")/../run_ai.sh"

[ -f "$F" ] || { echo "NG: playground/ai/agent.py がありません"; exit 1; }
grep -q "sk-ant" "$F" && { echo "NG: コードにキーらしきものがあります"; exit 1; }
python3 - "$F" <<'PY' || exit 1
import re, sys
src = open(sys.argv[1], encoding="utf-8").read()
names = set(re.findall(r'"name":\s*"(\w+)"', src))
defs = set(re.findall(r"^def (\w+)", src, re.M))
if len(names) < 3:
    print(f"NG: TOOLS の説明書が {len(names)} つしかありません（3つ以上にしてください）")
    sys.exit(1)
for n in sorted(names):
    if n not in defs:
        print(f"NG: ツール {n} の関数 def {n}() がありません")
        sys.exit(1)
    if len(re.findall(rf'["\']{n}["\']\s*:', src)) < 1:
        print(f"NG: ツール {n} が FUNCS に登録されていません")
        sys.exit(1)
PY
ai_have_key || { echo "OK: ツールの数と関数の対応は合っています。ANTHROPIC_API_KEY が無いので、実行のチェックはスキップします"; exit 0; }
OUT=$(ai_run agent.py "いま何時？ playground に何がある？") || { echo "NG: 実行でエラーになりました: $OUT"; exit 1; }
echo "$OUT" | grep -q "\[ツール実行\]" || { echo "NG: ツールが1回も呼ばれませんでした: $OUT"; exit 1; }
echo "OK: エージェントが動きました"
echo "$OUT" | tail -3
