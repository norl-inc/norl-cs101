#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
source "$ROOT/lessons/07-capstone/_lib.sh"
DIR="$ROOT/playground/capstone"
D="$DIR/Dockerfile"

[ -f "$D" ] || cap_ng "playground/capstone/Dockerfile がありません（README の cp を打ちましたか？）"
CODE=$(cap_code "$D")
echo "$CODE" | grep -qE '^COPY[[:space:]].*pyproject\.toml' || cap_ng "TODO 1: pyproject.toml を COPY する行がありません"
echo "$CODE" | grep -q 'uv\.lock' || cap_ng "TODO 1: uv.lock も COPY しましょう（ライブラリのバージョンを固定するファイル）"
echo "$CODE" | grep -qE '^RUN[[:space:]].*uv sync' || cap_ng "TODO 2: RUN uv sync ... がありません"
echo "$CODE" | grep -qE '^COPY[[:space:]].*main\.py' || cap_ng "TODO 3: main.py を COPY する行がありません"
echo "$CODE" | grep -qE '^COPY[[:space:]].*static' || cap_ng "TODO 3: static フォルダを COPY する行がありません"
echo "$CODE" | grep -qE '^CMD' || cap_ng "TODO 4: CMD（起動コマンド）がありません"
echo "$CODE" | grep -q '0\.0\.0\.0' || cap_ng "CMD に --host 0.0.0.0 がありません。127.0.0.1 のままだと、コンテナの外（あなたのブラウザ）から届きません"
[ -f "$DIR/uv.lock" ] || cap_ng "uv.lock がありません（7-1 の uv add でできるはずです）"

command -v docker >/dev/null 2>&1 || cap_ng "docker コマンドが見つかりません。Docker Desktop を入れてください（第4部の Docker のレッスン）。Dockerfile の見た目だけは OK でした"
docker info >/dev/null 2>&1 || cap_ng "Docker が動いていません。Docker Desktop のアプリを開いて、起動するのを待ってからもう一度 /check してください。Dockerfile の見た目だけは OK でした"

CAP_DOCKER_NAME="norl-memo-check-$$"
echo "docker build 中…（初回は1〜2分かかります）"
out=$(docker build -t "$CAP_DOCKER_NAME" "$DIR" 2>&1) || { echo "$out" | tail -12; cap_ng "docker build に失敗しました。上の最後の行を読んでみよう"; }

port=$(cap_free_port)
docker run -d --rm -p "$port:8000" --name "$CAP_DOCKER_NAME" "$CAP_DOCKER_NAME" >/dev/null 2>&1 || cap_ng "docker run に失敗しました"
BASE="http://127.0.0.1:$port"
for i in $(seq 1 40); do
  curl -s -o /dev/null "$BASE/openapi.json" && break
  sleep 0.5
done
curl -s -o /dev/null "$BASE/openapi.json" || { docker logs "$CAP_DOCKER_NAME" 2>&1 | tail -8; cap_ng "コンテナの 8000 番に外からつながりません。--host 0.0.0.0 と -p を確かめて、docker logs を読んでみよう"; }
cap_api_test
echo "OK: docker build → docker run で、コンテナの中のメモアプリに外から届きました"
