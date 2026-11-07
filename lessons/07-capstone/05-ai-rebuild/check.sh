#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT/lessons/07-capstone/_lib.sh"
DIR="$ROOT/playground/capstone-ai"

[ -d "$DIR" ] || cap_ng "playground/capstone-ai がありません。まず Claude に作ってもらいましょう（README の手順2〜）"
[ -f "$DIR/main.py" ] || cap_ng "playground/capstone-ai/main.py がありません。Claude に「main.py に app を置いて」と頼んでありますか？"
[ -f "$DIR/Dockerfile" ] || cap_ng "playground/capstone-ai/Dockerfile がありません（Claude に頼んだ内容に含まれていましたか？）"
[ -f "$DIR/COMPARE.md" ] || cap_ng "playground/capstone-ai/COMPARE.md がありません（README の手順7）"

python3 - "$DIR/COMPARE.md" <<'PY' || exit 1
import re, sys
t = open(sys.argv[1], encoding="utf-8").read()
if "TODO" in t:
    n = t.count("TODO")
    print(f"NG: COMPARE.md にまだ TODO が {n} か所あります。自分の言葉に書き換えてください"); sys.exit(1)
secs = re.split(r"(?m)^## ", t)[1:]
body = {s.split("\n", 1)[0].strip(): (s.split("\n", 1) + [""])[1] for s in secs}
diffs = [k for k in body if k.startswith("違い")]
if len(diffs) < 3:
    print("NG: 「## 違い1」「## 違い2」「## 違い3」の3つが必要です"); sys.exit(1)
for k in diffs:
    if len(re.sub(r"\s", "", body[k])) < 40:
        print(f"NG: 「{k}」の中身が短すぎます。私のコード／Claude のコードを、それぞれ1行ずつは書こう"); sys.exit(1)
for k in ("ログで確かめたこと", "追加してもらった機能"):
    if k not in body or len(re.sub(r"\s", "", body[k])) < 10:
        print(f"NG: 「## {k}」が空か短すぎます"); sys.exit(1)
PY

cap_start "$DIR"
cap_api_test
echo "OK: Claude が作ったアプリのAPIは、あなたの手作りと同じ形で動きました（追加・一覧・削除）"
echo "    そして違いを3つ、自分の言葉で書けました。これが「読める」ということです"
echo "    ※ 追加してもらった機能が本当に動くかは、ブラウザで自分の目で確かめてください"
