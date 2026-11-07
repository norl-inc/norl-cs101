#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/lessons/05-ai/07-limits"
F="$ROOT/playground/verify.md"

[ -f "$F" ] || { echo "NG: playground/verify.md がありません"; exit 1; }
COUNT=$(grep -c ERROR "$D/server.log")
FIRST=$(grep ERROR "$D/server.log" | head -1 | awk '{print $1}')
grep -Eq "(エラー|ERROR|error).*(^|[^0-9])${COUNT}([^0-9]|$)|(^|[^0-9])${COUNT}([^0-9]|$).*(件|エラー|ERROR|error)" "$F" \
  || { echo "NG: ログのエラー件数が正しく書かれていません。grep -c ERROR で数え直してみましょう"; exit 1; }
grep -q "$FIRST" "$F" || { echo "NG: 最初のエラーの時刻が書かれていないか、違っています。grep -n ERROR ... | head -1 で見てみましょう"; exit 1; }
grep -Eq "間違|違|誤|wrong|NG" "$F" || { echo "NG: 要約のどの番号が間違っていたかも書きましょう"; exit 1; }
echo "OK: 裏取りできました。AIの要約は、ログと比べると間違いだらけでした（件数 ${COUNT}、最初のエラー ${FIRST}）"
