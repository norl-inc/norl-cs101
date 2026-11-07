#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
T="$ROOT/playground/toychat.py"
F="$ROOT/playground/ai/context.py"
. "$(dirname "$0")/../run_ai.sh"

# --- 必須：おもちゃのチャットが、会話を全部送るようになっているか ---
[ -f "$T" ] || { echo "NG: playground/toychat.py がありません（cp でコピーしましたか？）"; exit 1; }
OUT=$(printf '私の名前はタカシです\n私の名前は何ですか？\nexit\n' | python3 "$T" 2>&1) \
  || { echo "NG: toychat.py がエラーになりました: $(echo "$OUT" | tail -1)"; exit 1; }
echo "$OUT" | grep -q "あなたの名前はタカシさんです" \
  || { echo "NG: 名前を答えられていません。make_context が、これまでの会話を全部返しているか見てみましょう"; exit 1; }
echo "OK: おもちゃのチャットが、会話を全部送るようになりました"

# --- 任意：API の実験6（context.py があるときだけ）---
[ -f "$F" ] || exit 0
grep -q "sk-ant" "$F" && { echo "NG: context.py にキーらしきものがあります。消して .env に移してください"; exit 1; }
python3 - "$F" <<'PY'
import re, sys
src = open(sys.argv[1], encoding="utf-8").read()
m = re.search(r"^history\s*=\s*(\[.*?^\]|\[.*?\])", src, re.S | re.M)
body = m.group(1) if m else ""
if '"assistant"' not in body and "'assistant'" not in body:
    print("（任意の実験6は、history に assistant（Claude の返事）がまだ入っていません。やらなくても合格です）")
    sys.exit(3)
if body.count('"user"') + body.count("'user'") < 2:
    print("（任意の実験6は、history に user の発言が2つ以上必要です（自己紹介と質問）。やらなくても合格です）")
    sys.exit(3)
PY
RC=$?
[ "$RC" -eq 3 ] && exit 0
[ "$RC" -ne 0 ] && exit 1
ai_have_key || { echo "OK: 実験6の履歴の形もできています（キーが無いので、実行はスキップします）"; exit 0; }
OUT=$(ai_run context.py) || { echo "NG: context.py の実行でエラーになりました: $OUT"; exit 1; }
echo "$OUT" | grep -q "実験6" || { echo "NG: 実験6まで実行できていません"; exit 1; }
echo "$OUT" | grep -q "history がまだ空" && { echo "NG: history がまだ空です"; exit 1; }
echo "OK: 本物の Claude でも、履歴を渡して最後まで動きました"
