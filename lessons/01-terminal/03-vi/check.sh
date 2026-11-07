#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/notes/memo.txt"

[ -f "$F" ] || { echo "NG: playground/notes/memo.txt がありません（1-2 をやってから）"; exit 1; }
LINES=$(wc -l < "$F" | tr -d ' ')
[ "$LINES" -ge 3 ] || { echo "NG: memo.txt が ${LINES} 行です（vi で1行足そう）"; exit 1; }
echo "OK: memo.txt は ${LINES} 行"
