# Claude に1回だけ質問して、答えと「使った量」を表示するプログラム。
# 実行: cd playground/ai && uv run python ask.py
import os
import sys

import anthropic
from dotenv import load_dotenv

load_dotenv()  # .env に書いた ANTHROPIC_API_KEY を、環境変数として読み込む（コードには書かない）

if not os.environ.get("ANTHROPIC_API_KEY"):
    print("ANTHROPIC_API_KEY が見つかりません。.env に書いてあるか確認してください。")
    sys.exit(1)

client = anthropic.Anthropic()  # キーは環境変数から自動で読まれる

QUESTION = "空はなぜ青いの？ 小学生にも分かるように2文で。"  # TODO: 好きな質問に変えてみよう

message = client.messages.create(
    model="claude-haiku-5-5",  # いちばん安くて速いモデル
    max_tokens=300,            # 返事の長さの上限（トークン）
    thinking={"type": "disabled"},  # じっくり考える機能は使わない（短い質問なので）
    messages=[{"role": "user", "content": QUESTION}],
)

print(message.content[0].text)
print("---")
print("入力トークン:", message.usage.input_tokens)
print("出力トークン:", message.usage.output_tokens)
# TODO: 質問を長くすると、どちらの数字が増える？ max_tokens を 20 にすると返事はどうなる？
