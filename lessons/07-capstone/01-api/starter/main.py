import os
import sqlite3

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# データベースのファイル名。環境変数 MEMO_DB があればそれ、なければ memo.db
DB_PATH = os.environ.get("MEMO_DB", "memo.db")

app = FastAPI()


def connect():
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row  # 1行を {"id": 1, "text": "..."} のように扱えるようにする
    return con


# 起動したとき、表（テーブル）が無ければ作る（できあがり）
_con = connect()
_con.execute(
    "CREATE TABLE IF NOT EXISTS memos ("
    " id INTEGER PRIMARY KEY AUTOINCREMENT,"
    " text TEXT NOT NULL)"
)
_con.commit()
_con.close()


class MemoIn(BaseModel):
    """POST で受け取る形： {"text": "牛乳を買う"}"""
    text: str


@app.get("/api/memos")
def list_memos():
    con = connect()
    # TODO 1: memos の全部を、id の小さい順に取り出して rows に入れる
    rows = None
    con.close()
    return [dict(r) for r in rows]


@app.post("/api/memos")
def add_memo(memo: MemoIn):
    con = connect()
    # TODO 2: memo.text を memos に追加する（値は ? で渡す）
    new_id = None  # TODO 2: 追加した行の id に置き換える
    con.commit()
    con.close()
    return {"id": new_id, "text": memo.text}


@app.delete("/api/memos/{memo_id}")
def delete_memo(memo_id: int):
    con = connect()
    # TODO 3: id が memo_id のメモを削除する
    con.commit()
    con.close()
    # チャレンジ（やらなくても合格）: 存在しない id のときは
    #   raise HTTPException(status_code=404) で「無いよ」と返してみよう
    return {"deleted": memo_id}
