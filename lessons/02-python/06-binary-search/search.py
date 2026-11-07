import random
import time

# 100万件の「偶数」が小さい順に並んだデータ：0, 2, 4, ... 1999998
data = list(range(0, 2_000_000, 2))


def linear_search(data, target):
    """先頭から1つずつ見ていく（線形探索）。"""
    steps = 0
    for i, x in enumerate(data):
        steps += 1
        if x == target:
            return i, steps
    return -1, steps


def binary_search(data, target):
    """真ん中を見て、探す範囲を半分にしていく（二分探索）。"""
    low = 0
    high = len(data) - 1
    steps = 0
    while low <= high:
        steps += 1
        mid = 0  # ① ここを直す：low と high の真ん中の位置（// は割り算の切り捨て）
        if data[mid] == target:
            return mid, steps
        elif False:  # ② ここを直す：真ん中の値より target が大きい？
            low = 0  # ③ ここを直す：右半分を探すので、low を mid の次に
        else:
            high = mid - 1  # 左半分を探す
    return -1, steps


def run(name, func, targets):
    start = time.perf_counter()
    total_steps = 0
    for t in targets:
        index, steps = func(data, t)
        total_steps += steps
        if index != -1 and data[index] != t:
            raise SystemExit("答えが違います：%s で %d を探したら位置 %d が返りました" % (name, t, index))
        if (index == -1) != (t % 2 == 1):
            raise SystemExit("答えが違います：%s の %d の結果が正しくありません" % (name, t))
    elapsed = time.perf_counter() - start
    print("%s：%.4f 秒（のべ %d ステップ）" % (name, elapsed, total_steps))
    return elapsed


if __name__ == "__main__":
    random.seed(1)
    # 偶数（ある）と奇数（ない）を混ぜて 50 回探す
    targets = [random.randrange(0, 2_000_000) for _ in range(50)]
    print("100万件のデータから 50 回探します")
    t1 = run("線形探索", linear_search, targets)
    t2 = run("二分探索", binary_search, targets)
    print("二分探索は線形探索の約 %d 倍速い" % (t1 / max(t2, 1e-9)))
