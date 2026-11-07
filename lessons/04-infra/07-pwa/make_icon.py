"""無地のアイコン（icon-192.png と icon-512.png）を作る。
使い方: python3 make_icon.py 出力フォルダ [色 例 2563eb]"""
import struct
import sys
import zlib


def png(size, rgb):
    row = b"\x00" + bytes(rgb) * size  # 各行の先頭に 0（フィルターなし）
    raw = row * size

    def chunk(kind, data):
        body = kind + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body))

    header = struct.pack(">IIBBBBB", size, size, 8, 2, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", header) + chunk(b"IDAT", zlib.compress(raw)) + chunk(b"IEND", b"")


out = sys.argv[1] if len(sys.argv) > 1 else "."
color = sys.argv[2] if len(sys.argv) > 2 else "2563eb"
rgb = tuple(int(color[i:i + 2], 16) for i in (0, 2, 4))
for size in (192, 512):
    path = f"{out}/icon-{size}.png"
    with open(path, "wb") as f:
        f.write(png(size, rgb))
    print("作りました:", path)
