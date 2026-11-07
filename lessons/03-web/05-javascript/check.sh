#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/web/index.html"

[ -f "$F" ] || { echo "NG: playground/web/index.html がありません（3-4 を先に）"; exit 1; }
grep -qi "<button" "$F" || { echo "NG: ボタン（<button>）がありません"; exit 1; }
grep -qi "<script" "$F" || { echo "NG: <script> がありません"; exit 1; }
grep -qiE "addEventListener|onclick" "$F" || { echo "NG: クリックで動く仕組み（addEventListener か onclick）がありません"; exit 1; }
echo "OK: ボタンとスクリプトのあるページができています"
