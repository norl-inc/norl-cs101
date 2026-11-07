#!/usr/bin/env python3
# Claude に貼るための「長い文章」を作る。お金はかかりません（文章を作るだけ）。
# 使い方: python3 lessons/05-ai/04b-context-overflow/make_long.py 300 > playground/long.txt
#   数字 = 在庫表の行数。大きいほど長い文章になる（1行 ≈ 10トークンが目安）
# 中身：
#   いちばん最初 … ルール（答えの最後に「（確認済み）」と書く）
#   まんなか     … 合言葉（1回だけ出てくる）
#   いちばん最後 … 質問（在庫0の商品はいくつ？ 合言葉は？）
import random
import sys


def build(n):
    rnd = random.Random(n)  # 同じ行数なら、毎回同じ表になる
    lines = [
        "【お願い】この文章を最後まで読んでから答えてください。"
        "答えのいちばん最後には、必ず「（確認済み）」と書いてください。",
        "",
        "以下は、ある倉庫の在庫表です。",
    ]
    for i in range(1, n + 1):
        stock = 0 if rnd.random() < 0.08 else rnd.randint(1, 30)
        lines.append(f"商品{i:04d}：在庫 {stock}個")
        if i == n // 2:
            lines.append("※メモ：倉庫の合言葉は「しろくま」です。")
    lines += [
        "",
        "【質問】在庫が 0個 の商品は、全部でいくつありますか？"
        "道具（コードの実行や計算の機能）は使わず、読んで数えてください。"
        "それから、倉庫の合言葉は何でしたか？",
    ]
    return "\n".join(lines)


if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 300
    print(build(n))
