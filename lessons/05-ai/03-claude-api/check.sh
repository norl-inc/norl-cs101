#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/ai/ask.py"
. "$(dirname "$0")/../run_ai.sh"

[ -f "$F" ] || { echo "NG: playground/ai/ask.py がありません"; exit 1; }
grep -q "sk-ant" "$F" "$ROOT"/playground/ai/*.py 2>/dev/null && { echo "NG: コードにキーらしきもの(sk-ant)があります。消して .env に移してください"; exit 1; }
grep -q "usage" "$F" || { echo "NG: usage（使ったトークン数）を表示していません"; exit 1; }
grep -q "messages.create" "$F" || { echo "NG: messages.create がありません"; exit 1; }
ai_have_key || { echo "OK: コードは読めました。ANTHROPIC_API_KEY が無いので、実行のチェックはスキップします"; exit 0; }
OUT=$(ai_run ask.py) || { echo "NG: 実行でエラーになりました: $OUT"; exit 1; }
echo "$OUT" | grep -q "入力トークン" || { echo "NG: トークン数が表示されていません"; exit 1; }
echo "OK: Claude から返事が来ました"
echo "$OUT" | tail -3
