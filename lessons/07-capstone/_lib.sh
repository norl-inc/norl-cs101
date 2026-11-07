#!/bin/bash
# 第7部の check.sh から読み込む共通部品（直接は実行しません）
# 使い方: source "$ROOT/lessons/07-capstone/_lib.sh"

CAP_PID=""
CAP_PORT=""
CAP_DB=""
CAP_LOG=""
BASE=""

cap_cleanup() {
  [ -n "$CAP_PID" ] && kill "$CAP_PID" 2>/dev/null
  # 念のため、そのポートで待っているプロセスも止める
  [ -n "$CAP_PORT" ] && lsof -ti "tcp:$CAP_PORT" -sTCP:LISTEN 2>/dev/null | xargs kill 2>/dev/null
  [ -n "$CAP_DB" ] && rm -f "$CAP_DB"
  [ -n "$CAP_LOG" ] && rm -f "$CAP_LOG"
  if [ -n "$CAP_DOCKER_NAME" ]; then
    docker rm -f "$CAP_DOCKER_NAME" >/dev/null 2>&1
    docker rmi -f "$CAP_DOCKER_NAME" >/dev/null 2>&1
  fi
}
trap cap_cleanup EXIT

cap_ng() { echo "NG: $*"; exit 1; }

cap_need_uv() {
  command -v uv >/dev/null 2>&1 || cap_ng "uv が見つかりません。第2部で入れた uv が使えるか、ターミナルで uv --version を打って確かめてください"
}

cap_free_port() {
  python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])'
}

# コメント行（# や // で始まる行）を除いたファイルの中身を出す
cap_code() { grep -vE '^[[:space:]]*(#|//)' "$1"; }

# $1 = プロジェクトのフォルダ。uv sync して、空いているポートで起動する。
cap_start() {
  local dir="$1" out
  [ -d "$dir" ] || cap_ng "$dir がありません"
  [ -f "$dir/main.py" ] || cap_ng "$dir/main.py がありません"
  [ -f "$dir/pyproject.toml" ] || cap_ng "$dir/pyproject.toml がありません（uv のプロジェクトになっていません）"
  cap_need_uv
  out=$(cd "$dir" && uv sync 2>&1) || { echo "$out" | tail -5; cap_ng "uv sync に失敗しました（ネットワークにつながっていますか？）"; }
  [ -x "$dir/.venv/bin/uvicorn" ] || cap_ng "uvicorn が入っていません。$dir で uv add fastapi uvicorn を実行してください"
  local port; port=$(cap_free_port)
  CAP_DB="${TMPDIR:-/tmp}/cap-check-$$.db"
  CAP_LOG="${TMPDIR:-/tmp}/cap-check-$$.log"
  rm -f "$CAP_DB"
  CAP_PORT="$port"
  ( cd "$dir" || exit 1; export MEMO_DB="$CAP_DB"; exec "$dir/.venv/bin/uvicorn" main:app --host 127.0.0.1 --port "$port" ) >"$CAP_LOG" 2>&1 &
  CAP_PID=$!
  BASE="http://127.0.0.1:$port"
  cap_wait_ready
}

cap_wait_ready() {
  local i
  for i in $(seq 1 40); do
    curl -s -o /dev/null "$BASE/openapi.json" && return 0
    if [ -n "$CAP_PID" ] && ! kill -0 "$CAP_PID" 2>/dev/null; then
      echo "--- サーバーのログ（最後の行を読んでみよう）---"; tail -8 "$CAP_LOG"
      cap_ng "サーバーが起動直後に止まりました"
    fi
    sleep 0.5
  done
  [ -n "$CAP_LOG" ] && tail -8 "$CAP_LOG"
  cap_ng "サーバーが起動しませんでした"
}

cap_pyjson() { python3 -c "$1" 2>/dev/null; }

# $BASE の API を 追加→一覧→削除 と叩いて確かめる
cap_api_test() {
  local r n id1 id2 code
  r=$(curl -s "$BASE/api/memos")
  n=$(echo "$r" | cap_pyjson 'import sys,json; d=json.load(sys.stdin); assert isinstance(d,list); print(len(d))') \
    || { [ -n "$CAP_LOG" ] && tail -5 "$CAP_LOG"; cap_ng "GET /api/memos が JSON の配列を返しません（返ってきたもの: ${r:0:80}）"; }
  [ "$n" = "0" ] || cap_ng "空のはずの GET /api/memos が $n 件返しました"

  r=$(curl -s -X POST "$BASE/api/memos" -H 'Content-Type: application/json' --data-binary '{"text":"テストA"}')
  id1=$(echo "$r" | cap_pyjson 'import sys,json; d=json.load(sys.stdin); assert d["text"]=="テストA"; assert isinstance(d["id"],int); print(d["id"])') \
    || { [ -n "$CAP_LOG" ] && tail -5 "$CAP_LOG"; cap_ng "POST /api/memos が {\"id\":数字, \"text\":...} を返しません（返ってきたもの: ${r:0:80}）"; }
  r=$(curl -s -X POST "$BASE/api/memos" -H 'Content-Type: application/json' --data-binary '{"text":"テストB"}')
  id2=$(echo "$r" | cap_pyjson 'import sys,json; print(json.load(sys.stdin)["id"])') || cap_ng "2回目の POST に失敗しました"

  r=$(curl -s "$BASE/api/memos")
  echo "$r" | cap_pyjson 'import sys,json; d=json.load(sys.stdin); assert [m["text"] for m in d]==["テストA","テストB"]' \
    || cap_ng "追加した2件が id の小さい順に並んで返ってきません（返ってきたもの: ${r:0:100}）"

  code=$(curl -s -o /dev/null -w '%{http_code}' -X DELETE "$BASE/api/memos/$id1")
  case "$code" in 2*) ;; *) cap_ng "DELETE /api/memos/$id1 が $code でした";; esac
  r=$(curl -s "$BASE/api/memos")
  echo "$r" | cap_pyjson 'import sys,json; d=json.load(sys.stdin); assert [m["text"] for m in d]==["テストB"]' \
    || cap_ng "削除したのに一覧から消えていません（返ってきたもの: ${r:0:100}）"

  code=$(curl -s -o /dev/null -w '%{http_code}' -X DELETE "$BASE/api/memos/99999")
  CAP_DELETE_MISSING="$code"
}
