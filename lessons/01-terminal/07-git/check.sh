#!/bin/bash
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
D="$ROOT/playground/mygit"

[ -d "$D/.git" ] || { echo "NG: playground/mygit で git init されていません"; exit 1; }
N=$(git -C "$D" rev-list --count HEAD 2>/dev/null || echo 0)
[ "$N" -ge 2 ] || { echo "NG: コミットが ${N} 個です（2個以上にしよう）"; exit 1; }
echo "OK: コミット ${N} 個"
git -C "$D" log --oneline
