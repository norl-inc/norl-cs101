#!/bin/bash
# 第5部のチェック用の道具（check.sh から読み込んで使う）。受講者は触らなくてOK。
# 前提：呼び出し側で ROOT（リポジトリの場所）を決めておく。

# APIキーが使えるか？（環境変数、または playground/ai/.env にある）
ai_have_key() {
  [ -n "$ANTHROPIC_API_KEY" ] && return 0
  grep -q '^ANTHROPIC_API_KEY=.\{8,\}' "$ROOT/playground/ai/.env" 2>/dev/null
}

# playground/ai の中で Python ファイルを実行する（uv があれば uv で）
ai_run() {
  ( cd "$ROOT/playground/ai" || exit 1
    if command -v uv >/dev/null 2>&1 && [ -f pyproject.toml ]; then
      uv run python "$@" 2>&1
    else
      python3 "$@" 2>&1
    fi )
}
