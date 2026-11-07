#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
DB="$ROOT/playground/db/app.db"
R="$ROOT/playground/db/read.py"

command -v sqlite3 >/dev/null || { echo "NG: sqlite3 コマンドが見つかりません"; exit 1; }
[ -f "$DB" ] || { echo "NG: playground/db/app.db がありません"; exit 1; }
sqlite3 "$DB" "SELECT COUNT(*) FROM todos;" >/dev/null 2>&1 || { echo "NG: todos という表がありません（CREATE TABLE todos ...）"; exit 1; }
[ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM todos;")" -ge 1 ] || { echo "NG: todos に行がありません（INSERT しましょう）"; exit 1; }
[ "$(sqlite3 "$DB" "SELECT COUNT(*) FROM todos WHERE done = 1;")" -ge 1 ] || { echo "NG: done が 1 の行がありません（UPDATE しましたか？）"; exit 1; }

[ -f "$R" ] || { echo "NG: playground/db/read.py がありません（starter.py をコピー）"; exit 1; }
grep -q 'sql = "TODO"' "$R" && { echo "NG: read.py の TODO がまだ残っています"; exit 1; }
OUT=$(python3 "$R" 2>&1) || { echo "NG: read.py がエラーです。最後の行を読んでみましょう: $(echo "$OUT" | tail -1)"; exit 1; }
WANT=$(sqlite3 "$DB" "SELECT COUNT(*) FROM todos WHERE done = 0;")
GOT=$(echo "$OUT" | grep -c '^やること:')
[ "$WANT" = "$GOT" ] || { echo "NG: 未完了は $WANT 件のはずですが、read.py は $GOT 件表示しました"; exit 1; }
echo "OK: 未完了の todo を $GOT 件、Python から読めました"
