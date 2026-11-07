#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
MEMO="$ROOT/playground/notes/memo.txt"
CSV="$ROOT/playground/py/memo.csv"

[ -f "$MEMO" ] || { echo "NG: playground/notes/memo.txt がありません（1-2 で作ったもの）"; exit 1; }
[ -f "$CSV" ] || { echo "NG: playground/py/memo.csv がありません"; exit 1; }
MEMO_LINES=$(grep -c '[^[:space:]]' "$MEMO")
CSV_LINES=$(grep -c '[^[:space:]]' "$CSV")
[ "$CSV_LINES" -ge 2 ] || { echo "NG: memo.csv が短すぎます（見出し＋データの行が要ります）"; exit 1; }
head -1 "$CSV" | grep -q ',' || { echo "NG: 1行目は 行番号,中身 のようにカンマ区切りの見出しにしよう"; exit 1; }
DATA=$((CSV_LINES - 1))
[ "$DATA" -eq "$MEMO_LINES" ] || { echo "NG: memo.txt は ${MEMO_LINES} 行なのに、CSV のデータは ${DATA} 行です"; exit 1; }
echo "OK: memo.txt の ${MEMO_LINES} 行が memo.csv に入っています"
