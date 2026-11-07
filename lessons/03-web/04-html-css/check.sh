#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/web/index.html"

[ -f "$F" ] || { echo "NG: playground/web/index.html がありません"; exit 1; }
grep -qi "<h1" "$F" || { echo "NG: 見出し（<h1>）がありません"; exit 1; }
grep -qi "<style" "$F" || { echo "NG: <style>（CSS）がありません"; exit 1; }
grep -qiE "color|background" "$F" || { echo "NG: 色の指定（color や background）がありません"; exit 1; }
echo "OK: 見出しと色つきのページができています"
