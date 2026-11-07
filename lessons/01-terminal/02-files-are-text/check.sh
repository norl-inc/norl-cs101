#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/notes/memo.txt"

[ -f "$F" ] || { echo "NG: playground/notes/memo.txt がありません"; exit 1; }
LINES=$(wc -l < "$F" | tr -d ' ')
[ "$LINES" -ge 2 ] || { echo "NG: memo.txt が ${LINES} 行です（2行以上にしよう）"; exit 1; }
echo "OK: memo.txt は ${LINES} 行"
