#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
NG=0
for d in model-test model-test2; do
  if [ -n "$(find "$ROOT/playground/$d" -type f 2>/dev/null | head -n 1)" ]; then
    echo "OK: playground/$d にファイルがある"
  else
    echo "NG: playground/$d にファイルがありません"; NG=1
  fi
done
exit $NG
