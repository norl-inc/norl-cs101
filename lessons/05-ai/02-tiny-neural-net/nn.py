#!/usr/bin/env python3
# 小さなニューラルネット（部品は数字だけ）。ライブラリなしの Python だけで動く。
# 「正解との差（loss）」が小さくなるように、数字を少しずつ直していく = 学習。
import math
import random

TASK = "AND"   # TODO: "AND" の次は "OR"、そして "XOR" を試す
HIDDEN = 4     # TODO: 中間の部品の数。XOR で 1 にしたらどうなる？
STEPS = 3000   # 何回直すか

tasks = {
    "AND": [([0, 0], 0), ([0, 1], 0), ([1, 0], 0), ([1, 1], 1)],
    "OR":  [([0, 0], 0), ([0, 1], 1), ([1, 0], 1), ([1, 1], 1)],
    "XOR": [([0, 0], 0), ([0, 1], 1), ([1, 0], 1), ([1, 1], 0)],  # 「どちらか片方だけ」
}
data = tasks[TASK]

random.seed(1)
# これが「モデルの中身」：ただの数字（重み）たち。最初はでたらめ。
w1 = [[random.uniform(-1, 1) for _ in range(2)] for _ in range(HIDDEN)]
b1 = [0.0] * HIDDEN
w2 = [random.uniform(-1, 1) for _ in range(HIDDEN)]
b2 = 0.0


def sigmoid(x):  # どんな数も 0〜1 に押し込む関数
    return 1 / (1 + math.exp(-x))


def predict(x):
    h = [sigmoid(sum(w1[j][i] * x[i] for i in range(2)) + b1[j]) for j in range(HIDDEN)]
    y = sigmoid(sum(w2[j] * h[j] for j in range(HIDDEN)) + b2)
    return h, y


print(f"課題: {TASK} / 中間の部品: {HIDDEN}個 / 数字の総数: {HIDDEN * 4 + 1}個")
lr = 0.5  # 1回にどれだけ直すか
for step in range(STEPS + 1):
    loss = 0.0
    for x, t in data:
        h, y = predict(x)
        loss += (y - t) ** 2          # 正解 t とのズレ
        # ズレを小さくする向きに、数字を少しずつ動かす（逆伝播）
        dy = 2 * (y - t) * y * (1 - y)
        for j in range(HIDDEN):
            dh = dy * w2[j] * h[j] * (1 - h[j])
            w2[j] -= lr * dy * h[j]
            for i in range(2):
                w1[j][i] -= lr * dh * x[i]
            b1[j] -= lr * dh
        b2 -= lr * dy
    if step % (STEPS // 6) == 0:
        print(f"{step:5d}回目  loss = {loss:.4f}")

print("--- 答え合わせ ---")
for x, t in data:
    _, y = predict(x)
    print(f"{x} → {y:.2f}（正解 {t}）")
print(f"最終loss: {loss:.4f}")
