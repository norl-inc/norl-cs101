#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
F="$ROOT/playground/my-skill/SKILL.md"
NG=0
if [ ! -f "$F" ]; then
  echo "NG: playground/my-skill/SKILL.md がありません"; exit 1
fi
echo "OK: SKILL.md がある"
if [ "$(head -n 1 "$F")" != "---" ]; then
  echo "NG: 先頭が --- ではありません（frontmatter がありません）"; NG=1
else
  echo "OK: 先頭が ---"
fi
grep -q '^name:' "$F" && echo "OK: name がある" || { echo "NG: name: がありません"; NG=1; }
grep -q '^description:' "$F" && echo "OK: description がある" || { echo "NG: description: がありません"; NG=1; }
exit $NG
