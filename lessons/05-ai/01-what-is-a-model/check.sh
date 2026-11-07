#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/lessons/05-ai/01-what-is-a-model"
F="$ROOT/playground/corpus.txt"

[ -f "$F" ] || { echo "NG: playground/corpus.txt がありません"; exit 1; }
N=$(tr -d '\n' < "$F" | python3 -c "import sys; print(len(sys.stdin.read()))")
[ "$N" -ge 100 ] || { echo "NG: 文章が短すぎます（${N}文字）。100文字以上にしてください"; exit 1; }
cmp -s "$F" "$D/corpus.txt" && { echo "NG: 用意された文章のままです。自分の文章に書き換えてください"; exit 1; }
OUT=$(python3 "$D/model.py" "$F" 2>&1) || { echo "NG: モデルがエラーになりました: $OUT"; exit 1; }
echo "$OUT" | grep -q "^1: " || { echo "NG: 生成文が出ていません"; exit 1; }
echo "OK: あなたの文章 ${N}文字からモデルができました"
echo "$OUT" | grep "^1: "
