"""パスワードのハッシュ化のひな形。TODO を埋めてください。
2つの関数 hash_password / verify_password は名前を変えないでください。"""
import hashlib
import hmac
import os


def hash_password(password):
    # TODO 1: 16バイトのランダムな塩を作る（ヒント: os.urandom(16)）
    salt = None

    # 塩とパスワードを混ぜて、わざと時間のかかる計算を 20万回繰り返す（総当たりを遅くするため）
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 200_000)

    # 保存する形は "塩$ハッシュ"（どちらも 16進数の文字列にする）
    return salt.hex() + "$" + digest.hex()


def verify_password(password, stored):
    salt_hex, digest_hex = stored.split("$")
    salt = bytes.fromhex(salt_hex)

    # TODO 2: 入力されたパスワードを、保存されていた塩で同じようにハッシュする
    digest = None

    # 比べる（hmac.compare_digest は、比べる時間でバレないための安全な比較）
    return hmac.compare_digest(digest.hex(), digest_hex)


if __name__ == "__main__":
    a = hash_password("hunter2")
    b = hash_password("hunter2")
    print("1回目:", a)
    print("2回目:", b)
    print("同じパスワードなのにハッシュは違う？", a != b)
    print("正しいパスワード:", verify_password("hunter2", a))
    print("間違ったパスワード:", verify_password("hunter3", a))
