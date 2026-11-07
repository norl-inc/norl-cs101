# 「モデルは、messages に入っているものしか知らない」を確かめるプログラム。
# 実行: cd playground/ai && uv run python context.py
# 呼び出しは全部で7回。どれも短いので、1回あたり数十〜百トークンほどです。
import os
import sys

import anthropic
from dotenv import load_dotenv

load_dotenv()
if not os.environ.get("ANTHROPIC_API_KEY"):
    print("ANTHROPIC_API_KEY が見つかりません。.env を確認してください。")
    sys.exit(1)

client = anthropic.Anthropic()


def ask(messages, system=None):
    """Claude を1回呼んで、返事と入力トークン数を表示する。"""
    kwargs = {"system": system} if system else {}
    r = client.messages.create(
        model="claude-haiku-5-5",
        max_tokens=200,
        thinking={"type": "disabled"},  # じっくり考える機能は使わない（短く・安く）
        messages=messages,
        **kwargs,
    )
    print(r.content[0].text)
    print(f"   （入力 {r.usage.input_tokens} トークン）\n")
    return r.content[0].text


print("=== 実験1：文脈なし ===")
ask([{"role": "user", "content": "今日の夕食、何にしよう？ 1つだけ答えて。"}])

print("=== 実験2：文脈あり ===")
# TODO: 同じ質問の前に、「冷蔵庫には卵とキャベツだけ」などの情報を足してみよう
ask([{"role": "user", "content": "今日の夕食、何にしよう？ 1つだけ答えて。"}])

print("=== 実験3：system プロンプト（役割・ルールを先に渡す）===")
ask(
    [{"role": "user", "content": "今日の夕食、何にしよう？ 1つだけ答えて。"}],
    system="あなたは超あっさり派の料理人です。必ず『〇〇一択』の形で答える。",
)  # TODO: system を別のキャラに変えてみよう

print("=== 実験4：例を見せる ===")
ask(
    [
        {
            "role": "user",
            "content": "文を『ポジ』か『ネガ』で分類して。\n"
            "例：楽しかった → ポジ\n例：最悪だった → ネガ\n"
            "分類：電車が遅れて疲れた →",
        }
    ]
)

print("=== 実験5：記憶はあるか？（呼び出しは別々）===")
ask([{"role": "user", "content": "私の名前はタカシです。覚えておいてね。"}])
ask([{"role": "user", "content": "私の名前は何でしたか？"}])  # ← 別の呼び出し。知っている？

print("=== 実験6：会話の履歴を自分で全部渡す ===")
# TODO: messages に「最初の自己紹介」「Claude の返事」「名前の質問」を順に入れて、
#       名前を答えられるようにしよう。形は次のとおり（役割 role は user と assistant が交互）：
#   [{"role": "user", "content": "..."},
#    {"role": "assistant", "content": "..."},
#    {"role": "user", "content": "..."}]
history = []
if history:
    ask(history)
else:
    print("（history がまだ空です。TODO を埋めましょう）")
