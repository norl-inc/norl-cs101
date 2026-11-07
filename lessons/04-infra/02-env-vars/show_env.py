"""環境変数 MY_API_KEY を読んで、先頭4文字だけ表示する。
カレントフォルダの .env があれば、そこから読み込む。"""
import os


def load_dotenv(path=".env"):
    # .env の「名前=値」の行を、環境変数として登録するだけの簡単な読み込み
    if not os.path.exists(path):
        return
    for line in open(path, encoding="utf-8"):
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        name, value = line.split("=", 1)
        os.environ.setdefault(name.strip(), value.strip())


load_dotenv()
key = os.environ.get("MY_API_KEY")
if not key:
    raise SystemExit("MY_API_KEY が見つかりません。.env に書きましたか？（このフォルダで実行していますか？）")
print("MY_API_KEY を読めました:", key[:4] + "*" * 8, "（全部は表示しません）")
