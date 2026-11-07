#!/bin/bash
# 任意レッスン。公開の前にやるべき「大事なものを入れていないか」の確認をします
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
DIR="$ROOT/playground/capstone"
ng() { echo "NG: $*"; exit 1; }

command -v git >/dev/null 2>&1 || ng "git が見つかりません（1-7 のレッスンで使いました）"
[ -d "$DIR" ] || ng "playground/capstone がありません"
[ -d "$DIR/.git" ] || ng "playground/capstone がまだ git の管理下ではありません。cd playground/capstone → git init から"
G=(git -C "$DIR")
"${G[@]}" rev-parse HEAD >/dev/null 2>&1 || ng "まだコミットが1つもありません。git add . → git commit -m ... まで進めよう"

"${G[@]}" check-ignore -q memo.db || ng ".gitignore に memo.db（データベース）が入っていません。メモの中身が公開されてしまいます"
"${G[@]}" check-ignore -q .venv/bin/python || ng ".gitignore に .venv/ が入っていません"
"${G[@]}" check-ignore -q .env || ng ".gitignore に .env が入っていません"

TRACKED=$("${G[@]}" ls-files)
echo "$TRACKED" | grep -qE '(^|/)(memo\.db|\.env)$|^\.venv/' && ng "コミットに memo.db / .env / .venv が入ってしまっています。git rm --cached で外して、コミットし直しましょう（入れてしまった秘密は、公開前なら履歴ごと消す必要があります。Claude に相談を）"
for f in main.py pyproject.toml Dockerfile; do
  echo "$TRACKED" | grep -qx "$f" || ng "$f がコミットに入っていません（git add . しましたか？）"
done

# 秘密っぽい文字が、コミット済みのファイルに無いか
HIT=$("${G[@]}" grep -nIE 'sk-ant-[A-Za-z0-9_-]{8,}|(API_KEY|SECRET|TOKEN|PASSWORD)[A-Za-z_]*[[:space:]]*[=:][[:space:]]*["'"'"'][A-Za-z0-9_./+-]{12,}' HEAD 2>/dev/null)
[ -z "$HIT" ] || { echo "$HIT" | head -3; ng "秘密っぽい文字列がコミットに入っています。上の行を確認してください（本物なら、鍵を作り直す必要があります）"; }

echo "OK: 公開しても困るものは、コミットに入っていません"
REMOTE=$("${G[@]}" remote -v | head -1)
if [ -n "$REMOTE" ]; then
  echo "    リモート: $REMOTE"
else
  echo "    まだ GitHub につないでいません（push したくなったら README の A を）"
fi
