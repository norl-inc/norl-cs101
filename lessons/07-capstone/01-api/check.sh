#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT/lessons/07-capstone/_lib.sh"
DIR="$ROOT/playground/capstone"

[ -f "$DIR/main.py" ] || cap_ng "playground/capstone/main.py がありません（README の cp -R を打ちましたか？）"
cap_start "$DIR"
cap_api_test
echo "OK: 追加・一覧・削除のAPIが動きました（自分の main.py を FastAPI が動かしています）"
if [ "$CAP_DELETE_MISSING" = "404" ]; then
  echo "    おまけ: 存在しない id の削除は 404 を返しています。チャレンジも達成！"
fi
