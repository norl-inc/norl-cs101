#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT/lessons/07-capstone/_lib.sh"
DIR="$ROOT/playground/capstone"
H="$DIR/static/index.html"

[ -f "$H" ] || cap_ng "playground/capstone/static/index.html がありません（README の cp を打ちましたか？）"
CODE=$(cap_code "$H")
echo "$CODE" | grep -q '\.json()' || cap_ng "index.html に .json() がありません（TODO 1: 返事を JSON として読む）"
[ "$(echo "$CODE" | grep -c 'fetch(')" -ge 3 ] || cap_ng "fetch( が3つ（一覧・追加・削除）ありません。TODO 1〜3 を埋めましたか？"
echo "$CODE" | grep -qE "POST" || cap_ng "追加（POST）の fetch がありません（TODO 2）"
echo "$CODE" | grep -qE "DELETE" || cap_ng "削除（DELETE）の fetch がありません（TODO 3）"
echo "$CODE" | grep -q 'JSON.stringify' || cap_ng "POST で送る中身を JSON.stringify で文字にしていません（TODO 2）"

grep -q "StaticFiles" "$DIR/main.py" || cap_ng "main.py で static フォルダを配信していません（README の手順3）"
cap_start "$DIR"

PAGE=$(curl -s "$BASE/")
echo "$PAGE" | grep -qi "<html" || cap_ng "http://localhost:ポート/ を開いても HTML が返ってきません（返ってきたもの: ${PAGE:0:80}）"
cap_api_test
echo "OK: / で画面が返り、/api/memos も生きています。fetch が3つ（GET・POST・DELETE）書けています。"
echo "    あとはブラウザで本当に動くか、DevTools の Network を開いて自分の目で確かめよう。"
