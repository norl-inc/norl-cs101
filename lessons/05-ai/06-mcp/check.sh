#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/ai/server.py"
. "$(dirname "$0")/../run_ai.sh"

[ -f "$F" ] || { echo "NG: playground/ai/server.py がありません"; exit 1; }
N=$(grep -c "^@mcp.tool" "$F")
[ "$N" -ge 3 ] || { echo "NG: @mcp.tool() の付いたツールが ${N} つです。add_note を足して3つにしてください"; exit 1; }
python3 -m py_compile "$F" 2>/dev/null || { echo "NG: server.py に文法のミスがあります: $(python3 -m py_compile "$F" 2>&1 | tail -1)"; exit 1; }
rm -rf "$ROOT/playground/ai/__pycache__"
grep -q "def add_note" "$F" || { echo "NG: add_note という関数がありません"; exit 1; }
OUT=$(ai_run -c "
import asyncio, server
print(' '.join(sorted(t.name for t in asyncio.run(server.mcp.list_tools()))))" 2>&1) || {
  if echo "$OUT" | grep -q "No module named 'mcp"; then
    echo "OK: ツールの形は合っています。mcp が入っていない（uv add mcp）ので、読み込みのチェックはスキップします"; exit 0
  fi
  echo "NG: 読み込みでエラーになりました: $(echo "$OUT" | tail -1)"; exit 1; }
echo "$OUT" | grep -q "add_note" || { echo "NG: ツール一覧に add_note がありません（@mcp.tool() を付けましたか？）: $OUT"; exit 1; }
echo "OK: MCP サーバーが読み込めました。ツール: $OUT"
