#!/usr/bin/env python3
# おもちゃのチャット。お金もキーも要りません。
# 中身は2つに分かれています：
#   ・モデル（toy_model）……受け取った文章だけを見て、返事を1つ返す。何も覚えない
#   ・アプリ（下の while の部分）……会話を持っていて、毎回モデルに文章を送る
# 使い方: python3 playground/toychat.py     終わるとき: exit と打つ
import re

# ===== 設定（5-4b で使います。5-4 では触らなくてOK）=====
WINDOW = 0   # モデルに送れる文章の上限（文字数）。0 = 上限なし
SYSTEM = ""  # 毎回いちばん前に付けるルール（system プロンプト）。"" = なし

# /long と打つと、この長い文章を「貼った」ことになる
LONG_TEXT = (
    "【会議メモ】来週の予定を確認しました。月曜は資料づくり、火曜は打ち合わせ、"
    "水曜はお客さんの訪問、木曜は見直し、金曜はまとめです。\n"
    "会議室は3階の奥を使います。お昼はそれぞれ自由です。"
    "資料は前日までに共有フォルダへ入れてください。\n"
    "次回も同じ時間に集まります。欠席するときは、前の日までに連絡してください。"
)


# ===== モデル（おもちゃ）=====
# 本物のモデルは 5-2 のような数字のかたまりです。これは、そのふりをする小さな関数。
# 本物と同じなのは1つだけ：受け取った文章（context）しか見ない。記憶する場所を持たない。
def toy_model(context):
    lines = context.split("\n")
    # いまの発言 = 最後の「あなた：」から後ろ
    starts = [i for i, line in enumerate(lines) if line.startswith("あなた：")]
    if starts:
        k = starts[-1]
        question = "\n".join(lines[k:]).removeprefix("あなた：")
        before = lines[:k]
    else:  # 切れて「あなた：」が残っていない
        question, before = lines[-1], lines[:-1]

    # ルール「語尾に「〇〇」」が文章のどこかにあれば、それに従う
    rules = re.findall(r"語尾に「(.+?)」", context)
    ending = rules[-1] if rules else ""

    if "名前" in question and ("？" in question or "?" in question or "何" in question):
        name = None
        for line in before:  # いまの発言より前に、名前が書いてあるか探す
            m = re.search(r"名前は(.+?)(?:です|だよ|。|！|$)", line)
            if m and line.startswith(("あなた：", "ルール：")) and "何" not in m.group(1):
                name = m.group(1)
        if name:
            reply = f"あなたの名前は{name}さんです"
        else:
            reply = "ごめんなさい、分かりません（受け取った文章の中に、名前が書いてありません）"
    elif "語尾に「" in question:
        reply = "わかりました"
    elif m := re.search(r"名前は(.+?)(?:です|だよ|。|！|$)", question):
        reply = f"はじめまして、{m.group(1)}さん！"
    elif "覚えて" in question:
        reply = "はい、覚えました！"
    else:
        head = question.replace("\n", "")[:12]
        reply = f"なるほど、「{head}…」ですね"
    return reply + ending


# ===== アプリ（ハーネス）=====
def make_context(history):
    """モデルに送る文章を作る。history は、これまでの会話（1発言 = 1要素）"""
    # TODO（5-4）: いまは「最後の発言」だけを送っています。
    #   これまでの会話を全部送るように、下の1行を直してください。
    #   ヒント: リストを改行でつなぐと "\n".join(history)
    return history[-1]


def show(context, cut):
    print(f"  ┌─ モデルに送った文章（コンテキスト）：{len(context)}文字")
    for line in context.split("\n"):
        print(f"  │ {line}")
    if cut:
        print(f"  └─ ✂ 上限 {WINDOW} 文字を超えたので、古いほうから {cut} 文字を捨てました")
    else:
        print("  └─")


def main():
    history = []  # これまでの会話。覚えているのはモデルではなく、アプリのこのリスト
    print("おもちゃのチャットです。exit で終わります。/long で長い文章を貼ります。")
    print("（このおもちゃでは 1文字 = 1トークン と数えます）")
    while True:
        try:
            user = input("あなた> ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if user in ("exit", "quit", "おわり"):
            break
        if not user:
            continue
        if user == "/long":
            user = LONG_TEXT
            print(f"（長い文章を貼りました：{len(user)}文字）")
        history.append("あなた：" + user)

        context = make_context(history)
        rule_line = ("ルール：" + SYSTEM) if SYSTEM else ""
        cut = 0
        if WINDOW:
            room = max(WINDOW - len(rule_line) - (1 if rule_line else 0), 0)
            if len(context) > room:  # 入りきらない分は、古いほう（前）から捨てる
                cut = len(context) - room
                context = context[cut:].lstrip("\n")
        if rule_line:
            context = rule_line + "\n" + context  # ルールは毎回いちばん前に付ける

        show(context, cut)
        reply = toy_model(context)
        print("AI> " + reply)
        history.append("AI：" + reply)


if __name__ == "__main__":
    main()
