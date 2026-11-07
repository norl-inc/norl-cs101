# いちばん小さい MCP サーバー：Claude に「手帳」を見せる。
# MCP = AI 向けの API。ここに書いた関数が、Claude の「ツール」として並ぶ。
from pathlib import Path

try:
    from mcp.server.mcpserver import MCPServer as Server   # mcp 2.x
except ImportError:
    from mcp.server.fastmcp import FastMCP as Server       # mcp 1.x

mcp = Server("mini-notes")
NOTES = Path(__file__).resolve().parent.parent / "notes"   # playground/notes
NOTES.mkdir(exist_ok=True)


@mcp.tool()
def list_notes() -> str:
    """手帳にあるメモの名前を一覧にして返す"""   # ← この説明文が、Claude への「説明書」になる
    return "\n".join(sorted(p.stem for p in NOTES.glob("*.txt"))) or "(メモはまだありません)"


@mcp.tool()
def read_note(name: str) -> str:
    """名前を指定して、メモの中身を返す"""
    path = NOTES / (Path(name).name + ".txt")   # Path(name).name … フォルダの外を覗かれないように
    return path.read_text(encoding="utf-8") if path.exists() else "そのメモはありません"


# TODO: 3つ目のツール add_note(name: str, text: str) -> str を足そう。
#       メモを NOTES / (name + ".txt") に書いて、「保存しました」と返す。
#       説明文（""" """）を忘れずに。Claude はそれを読んで使うか決めます。

if __name__ == "__main__":
    mcp.run()  # 標準入出力（stdio）で、Claude と会話するサーバーになる
