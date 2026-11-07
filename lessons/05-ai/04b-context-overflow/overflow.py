# 長い文章を、本物の Claude（Haiku）に1回だけ渡して、どこまで正しく読めるかを見る。（任意・有料）
# 実行: cd playground/ai && uv run python overflow.py 300
#   数字 = 在庫表の行数（最大 2000）。送る前に、トークン数を数えて見せ、y を押したときだけ送ります。
import os
import random
import sys

import anthropic
from dotenv import load_dotenv

MODEL = "claude-haiku-5-5"
MAX_LINES = 2000  # これ以上は送らない（お金の安全のため）

load_dotenv()
if not os.environ.get("ANTHROPIC_API_KEY"):
    print("ANTHROPIC_API_KEY が見つかりません。.env を確認してください。")
    sys.exit(1)


def build(n):
    """make_long.py と同じ文章を作る。最初にルール、まんなかに合言葉、最後に質問"""
    rnd = random.Random(n)
    lines = [
        "【お願い】この文章を最後まで読んでから答えてください。"
        "答えのいちばん最後には、必ず「（確認済み）」と書いてください。",
        "",
        "以下は、ある倉庫の在庫表です。",
    ]
    zeros = 0
    for i in range(1, n + 1):
        stock = 0 if rnd.random() < 0.08 else rnd.randint(1, 30)
        zeros += stock == 0
        lines.append(f"商品{i:04d}：在庫 {stock}個")
        if i == n // 2:
            lines.append("※メモ：倉庫の合言葉は「しろくま」です。")
    lines += [
        "",
        "【質問】在庫が 0個 の商品は、全部でいくつありますか？"
        "道具（コードの実行や計算の機能）は使わず、読んで数えてください。"
        "それから、倉庫の合言葉は何でしたか？",
    ]
    return "\n".join(lines), zeros


n = int(sys.argv[1]) if len(sys.argv) > 1 else 100
if not 1 <= n <= MAX_LINES:
    print(f"行数は 1〜{MAX_LINES} にしてください")
    sys.exit(1)

text, zeros = build(n)
messages = [{"role": "user", "content": text}]
client = anthropic.Anthropic()

# 1. 送る前に数える（数えるだけなら、お金はかかりません）
count = client.messages.count_tokens(model=MODEL, messages=messages).input_tokens
print(f"在庫表 {n} 行 / {len(text)} 文字 → 送ると約 {count} トークンです")
if input("送りますか？ (y/n) ").strip().lower() != "y":
    print("送りませんでした")
    sys.exit(0)

# 2. 1回だけ送る
r = client.messages.create(
    model=MODEL,
    max_tokens=400,                  # 返事の長さの上限
    thinking={"type": "disabled"},   # じっくり考える機能は使わない（短く・安く）
    messages=messages,
)
answer = "".join(b.text for b in r.content if b.type == "text")
print("--- Claude の答え ---")
print(answer)

# 3. 答え合わせ（本当の答えは Python が数えてある）
print("--- 答え合わせ ---")
print(f"在庫0の商品：本当は {zeros} 個")
print(f"合言葉（まんなか）：{'○ 答えた' if 'しろくま' in answer else '× 答えていない'}")
print(f"ルール（いちばん最初）：{'○ 守った' if '（確認済み）' in answer else '× 守っていない'}")
print(f"入力 {r.usage.input_tokens} トークン / 出力 {r.usage.output_tokens} トークン")
