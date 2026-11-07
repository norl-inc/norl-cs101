#!/usr/bin/env python3
# 「次の1文字を予想する」だけの、ミニ言語モデル。
# 使い方: python3 model.py [学習させる文章ファイル] [何文字前まで見るか(1〜3)]
import random
import sys
from collections import defaultdict
from pathlib import Path

here = Path(__file__).resolve().parent
corpus_path = Path(sys.argv[1]) if len(sys.argv) > 1 else here / "corpus.txt"
order = int(sys.argv[2]) if len(sys.argv) > 2 else 1   # 何文字前まで見るか

text = corpus_path.read_text(encoding="utf-8").replace("\n", "")
tokens = list(text)  # 1文字 = 1トークン（本物はもう少し賢い切り方をする）

# --- 学習：「この並びのあとに、何が来たか」を数えるだけ ---
table = defaultdict(list)
for i in range(len(tokens) - order):
    before = "".join(tokens[i : i + order])
    table[before].append(tokens[i + order])

print(f"文章の長さ: {len(tokens)} トークン / 覚えた並び: {len(table)} 種類")
print("--- 覚えたことの一部 ---")
for before in list(table)[:5]:
    print(f"「{before}」のあと → {table[before]}")

# --- 生成：次の1文字を選ぶ、を繰り返す ---
print("--- 生成 ---")
for n in range(3):
    out = text[:order]  # 最初の文字は学習文の先頭を借りる
    for _ in range(40):
        before = out[-order:]
        if before not in table:
            break  # 続きを知らない
        out += random.choice(table[before])  # ← ここが「予想」。サイコロで選んでいる
    print(f"{n + 1}: {out}")
