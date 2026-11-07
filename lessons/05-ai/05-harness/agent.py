# 20行ちょっとで作る「エージェント」。モデル + ハーネス（このプログラム）+ ツール。
# 実行: cd playground/ai && uv run python agent.py "いま何時？"
import os
import sys
from datetime import datetime
from pathlib import Path

import anthropic
from dotenv import load_dotenv

load_dotenv()
if not os.environ.get("ANTHROPIC_API_KEY"):
    print("ANTHROPIC_API_KEY が見つかりません。.env を確認してください。")
    sys.exit(1)

# --- ツール：Claude が「使いたい」と言えるもの。実際に動かすのは私たち ---
def get_current_time():
    return datetime.now().strftime("%Y-%m-%d %H:%M")

def list_playground_files():
    return "\n".join(sorted(p.name for p in Path("..").glob("*"))) or "(空)"

FUNCS = {"get_current_time": get_current_time, "list_playground_files": list_playground_files}
TOOLS = [  # Claude に見せる「説明書」
    {"name": "get_current_time", "description": "今の日付と時刻を返す",
     "input_schema": {"type": "object", "properties": {}}},
    {"name": "list_playground_files", "description": "playground フォルダにあるファイル名の一覧を返す",
     "input_schema": {"type": "object", "properties": {}}},
    # TODO: ここに3つ目のツールの説明書を足す（FUNCS にも同じ名前で関数を足すこと）
]

# --- ハーネス：モデルを呼ぶ → ツールを頼まれたら実行 → 結果を返す、の繰り返し ---
client = anthropic.Anthropic()
messages = [{"role": "user", "content": " ".join(sys.argv[1:]) or "いま何時？ playground に何がある？"}]
while True:
    r = client.messages.create(model="claude-haiku-5-5", max_tokens=500, tools=TOOLS, messages=messages)
    messages.append({"role": "assistant", "content": r.content})
    if r.stop_reason != "tool_use":  # ツールを頼まれていない = 答えが出た
        break
    results = []
    for block in r.content:
        if block.type == "tool_use":
            print(f"[ツール実行] {block.name}({block.input})")
            results.append({"type": "tool_result", "tool_use_id": block.id, "content": FUNCS[block.name](**block.input)})
    messages.append({"role": "user", "content": results})

print("".join(b.text for b in r.content if b.type == "text"))
