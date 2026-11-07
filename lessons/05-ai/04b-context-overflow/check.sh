#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
T="$ROOT/playground/toychat.py"

[ -f "$T" ] || { echo "NG: playground/toychat.py がありません（5-4 のステップ4と5を先にやりましょう）"; exit 1; }
python3 - "$T" <<'PY'
import importlib.util, re, subprocess, sys
path = sys.argv[1]
spec = importlib.util.spec_from_file_location("toychat", path)
mod = importlib.util.module_from_spec(spec)
try:
    spec.loader.exec_module(mod)
except Exception as e:
    print(f"NG: toychat.py を読み込めません: {e}")
    sys.exit(1)

try:
    sent = mod.make_context(["あなた：一つ目", "AI：二つ目"])
except Exception as e:
    sent = ""
if "一つ目" not in sent or "二つ目" not in sent:
    print("NG: make_context が会話を全部送っていません（5-4 のステップ5）")
    sys.exit(1)

window = getattr(mod, "WINDOW", 0)
system = getattr(mod, "SYSTEM", "")
if not isinstance(window, int) or window <= 0:
    print("NG: WINDOW が 0 のままです。100 などの小さな数にして、溢れるようにしましょう")
    sys.exit(1)
m = re.search(r"語尾に「(.+?)」", system or "")
if not m:
    print("NG: SYSTEM に「語尾に「〇〇」」のルールが書かれていません")
    sys.exit(1)
ending = m.group(1)

# 名前を言う → 長い文章を何度も貼る → 名前を聞く
script = "私の名前はタカシです\n" + "/long\n" * 3 + "私の名前は何ですか？\nexit\n"
r = subprocess.run([sys.executable, path], input=script, capture_output=True, text=True, timeout=20)
if r.returncode != 0:
    print("NG: 実行でエラーになりました: " + (r.stderr.strip().splitlines() or ["?"])[-1])
    sys.exit(1)
out = r.stdout
if "✂" not in out:
    print(f"NG: 溢れていません（WINDOW = {window} は大きすぎるようです）。もっと小さくしましょう")
    sys.exit(1)
replies = [line for line in out.splitlines() if "AI> " in line]
last = replies[-1].split("AI> ", 1)[1] if replies else ""
if "タカシさんです" in last and "タカシ" not in system:
    print("NG: 溢れたはずなのに名前を答えています。make_context と WINDOW を見直しましょう")
    sys.exit(1)
if not last.endswith(ending):
    print(f"NG: 溢れたあと、語尾「{ending}」が守られていません。SYSTEM が毎回付いているか見てみましょう")
    sys.exit(1)
print(f"OK: 窓 {window} 文字で溢れても、SYSTEM のルール（語尾「{ending}」）は最後まで守られました")
print("   最後の返事: " + last)
PY
