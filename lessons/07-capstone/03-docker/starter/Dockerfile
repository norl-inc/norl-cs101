# メモアプリの「引っ越しセット」の作り方メモ
# 上から順に実行されて、1行ごとに層（レイヤー）が積まれていきます。

# 土台：Python が入った小さな Linux（できあがり）
FROM python:3.12-slim

# uv をこの Linux に持ち込む（できあがり）
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# 以降の作業はコンテナの中の /app で行う
WORKDIR /app

# 先に「ライブラリの一覧」だけコピーして入れる（変更が少ないので、キャッシュが効いて速くなる）
# TODO 1: pyproject.toml と uv.lock を /app にコピーする（COPY）
# TODO 2: uv sync --frozen --no-dev を実行する（RUN）

# ライブラリが入った場所を、コマンドの探し先に足す（できあがり）
ENV PATH="/app/.venv/bin:$PATH"

# TODO 3: アプリ本体を /app にコピーする（main.py と static フォルダ）

# データベースの置き場所（できあがり）。main.py が環境変数 MEMO_DB を読みます
RUN mkdir -p /data
ENV MEMO_DB=/data/memo.db

# このコンテナは 8000 番で待ちます（メモ書きのようなもの。実際に開けるのは docker run -p）
EXPOSE 8000

# TODO 4: 起動コマンド（CMD）。uvicorn main:app を、ポート 8000 で起動する。
#   注意：どのアドレスで待つか（--host）も指定が必要。コンテナの外から届くのは？
