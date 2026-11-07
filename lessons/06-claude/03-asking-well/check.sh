#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/ask2/todo.html"
if [ -f "$F" ]; then
  echo "OK: playground/ask2/todo.html がある"
  exit 0
fi
echo "NG: playground/ask2/todo.html がありません"
exit 1
