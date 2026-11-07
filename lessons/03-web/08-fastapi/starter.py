# 3-8 の出発点。playground/api/main.py にコピーして使う。
from fastapi import FastAPI

app = FastAPI()


@app.get("/hello")
def hello():
    return {"message": "こんにちは"}


# TODO: /double を作る。
#   /double?n=21 にアクセスすると {"n": 21, "result": 42} を返す。
#   ヒント: 上の hello をまねて、関数の引数に n: int を書く。
