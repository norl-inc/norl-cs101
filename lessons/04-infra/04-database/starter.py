"""todos 表から、まだ終わっていないものを表示するひな形。
playground/db/read.py にコピーして、TODO を埋めてください。"""
import os
import sqlite3

# app.db はこのファイルと同じフォルダにある
db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "app.db")
con = sqlite3.connect(db_path)

# TODO: done が 0 の todo の title だけを取る SQL を、"TODO" の代わりに書く
sql = "TODO"

for (title,) in con.execute(sql):
    print("やること:", title)

con.close()
