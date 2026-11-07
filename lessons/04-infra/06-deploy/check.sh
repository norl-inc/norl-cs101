#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
W="$ROOT/playground/web"

[ -f "$W/index.html" ] || { echo "NG: playground/web/index.html がありません"; exit 1; }
[ -d "$W/.git" ] || { echo "NG: playground/web が git になっていません（git init -b main）"; exit 1; }
URL=$(cd "$W" && git remote get-url origin 2>/dev/null) || { echo "NG: origin がありません（git remote add origin ...）"; exit 1; }

# https://github.com/USER/REPO(.git) または git@github.com:USER/REPO(.git) から USER と REPO を取る
PATHPART=$(echo "$URL" | sed -E 's#^(https://github.com/|git@github.com:)##; s#\.git$##')
case "$URL" in *github.com*) ;; *) echo "NG: origin が GitHub ではありません: $URL"; exit 1;; esac
USER_NAME=${PATHPART%%/*}
REPO=${PATHPART#*/}
USER_LC=$(echo "$USER_NAME" | tr 'A-Z' 'a-z')
if [ "$(echo "$REPO" | tr 'A-Z' 'a-z')" = "$USER_LC.github.io" ]; then
  SITE="https://$USER_LC.github.io/"
else
  SITE="https://$USER_LC.github.io/$REPO/"
fi

[ -n "$(cd "$W" && git ls-remote origin 2>/dev/null | head -1)" ] || { echo "NG: GitHub に push できていないようです（git push -u origin main）。ネットワークも確認してください"; exit 1; }

CODE=$(curl -s -o /dev/null -m 15 -w '%{http_code}' "$SITE")
case "$CODE" in
  200) echo "OK: 公開されています → $SITE" ;;
  000) echo "NG: ネットワークにつながりません。つながる場所でもう一度どうぞ"; exit 1 ;;
  404) echo "NG: $SITE はまだ 404 です。Settings → Pages の設定と、1〜2分の待ち時間を確認"; exit 1 ;;
  *)   echo "NG: $SITE が HTTP $CODE を返しました"; exit 1 ;;
esac
