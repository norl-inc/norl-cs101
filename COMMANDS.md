# コマンドと略語の「名前の由来」

コマンドの多くは英語の略です。**元の英語を知ると、意味ごと覚えられます。**
`cd` を「シーディー」と覚えるより、「change directory（ディレクトリを変える）」と覚えるほうが忘れません。

## ターミナルのコマンド

| コマンド | 元の英語 | 意味 | 初登場 |
|---|---|---|---|
| `pwd` | print working directory | いま作業しているフォルダを表示 | 1-1 |
| `ls` | list | 中身を一覧 | 1-1 |
| `cd` | change directory | フォルダを移る | 1-1 |
| `mkdir` | make directory | フォルダを作る | 1-2 |
| `echo` | echo（こだま） | 言ったことをそのまま返す | 0-2 |
| `cat` | concatenate（つなげる） | ファイルの中身をつなげて表示 | 1-2 |
| `cp` | copy | コピー | 2-6 |
| `mv` | move | 移動・名前変更 | |
| `rm` | remove | 消す（ゴミ箱に行かない！） | 4-5 |
| `vi` | visual（editor） | 画面を見ながら編集するエディタ | 1-3 |
| `nano` | nano（とても小さい） | 小さなエディタ | 1-3 |
| `chmod` | change mode | ファイルの許可を変える | 1-4 |
| `rwx` | read / write / execute | 読む／書く／実行する | 1-4 |
| `tail -f` | tail（しっぽ） + follow | ファイルの最後を追いかけて表示 | 1-6 |
| `grep` | global regular expression print | 文字のパターンを探して表示 | 1-6 |
| `head` | head（頭） | ファイルの最初の数行を表示 | 4-2 |
| `ls -a` | list **a**ll | 隠しファイル（`.` で始まる）も表示 | 1-7 |
| `\|`（パイプ） | pipe（管） | 左の出力を右のコマンドに流し込む | 4-1 |
| `pbcopy` | pasteboard copy | 出力をクリップボードにコピー | 5-4b |
| `wc` | word count | 行数・単語数を数える | 5-7 |
| `git` | （作者の冗談で付けた名前） | セーブポイントを作る道具 | 1-7 |
| `brew` | Homebrew（自家醸造） | Mac に道具を入れる | 2-1 |
| `curl` | client URL | URL にアクセスして結果を表示 | 3-3 |
| `ps` | process status | 動いているプロセスを表示 | 4-1 |
| `lsof` | list open files | 開いているファイル（とポート）を一覧 | 4-1 |
| `kill` | kill | プロセスを止める | 4-1 |
| `env` | environment | 環境変数の一覧を見る | 4-2 |
| `export` | export（外に出す） | 環境変数を子プロセスに渡す | 4-2 |
| `ipconfig` | IP configuration | IPアドレスの設定を見る | 4-3 |
| `nslookup` | name server lookup | ネームサーバー（DNS）に名前を引く | 0-3 |
| `dig` | domain information groper（探る道具） | DNS をくわしく調べる | 4-3 |
| `sqlite3` | SQLite（SQL + lite）のバージョン3 | SQLite のデータベースを操作 | 4-4 |
| `sudo` | superuser do | 管理者として実行（慎重に！） | |
| `ssh` | secure shell | 別のコンピュータに安全に入る | |
| `man` | manual | コマンドの説明書を読む | |

## よく出る略語

| 略語 | 元の英語 | ひとことで | 初登場 |
|---|---|---|---|
| CLI | Command Line Interface | 文字で操作する画面（ターミナル） |  |
| URL | Uniform Resource Locator | ネット上の住所 | 0-1 |
| HTTP / HTTPS | HyperText Transfer Protocol（Secure） | Web のやりとりのルール（S は暗号化） | 0-1 / 4-7 |
| IP | Internet Protocol | ネットの住所（番号）のルール | 0-3 |
| DNS | Domain Name System | 名前→IPアドレスの電話帳 | 0-3 |
| HTML | HyperText Markup Language | Webページの骨組み | 3-1 |
| CSS | Cascading Style Sheets | Webページの見た目 | 3-4 |
| JS | JavaScript | Webページを動かす言語 | 3-5 |
| JSON | JavaScript Object Notation | データの書き方（辞書の形） | 2-3 |
| API | Application Programming Interface | プログラム向けの窓口 | 2-3 |
| SQL | Structured Query Language | データベースへの質問の言葉 | 4-4 |
| VM | Virtual Machine | コンピュータの中のコンピュータ | 4-5 |
| PWA | Progressive Web App | アプリのように使えるWebサイト | 4-7 |
| LLM | Large Language Model | 大規模言語モデル（Claude など） |  |
| MCP | Model Context Protocol | AI 向けの窓口のルール | 3-8 |
| TOML | Tom's Obvious Minimal Language | 設定を書く形式（`pyproject.toml`） | 2-1 |
| CSV | Comma-Separated Values | カンマで区切った表の文字 | 2-5 |
| XHR | XMLHttpRequest | あとから別の場所に聞く通信（DevTools の Fetch/XHR） | 3-1 |
| PID | Process ID | プロセスの番号 | 4-1 |
| OS | Operating System | 基本ソフト（macOS など） | 4-5 |
| PNG | Portable Network Graphics | 画像の形式 | 4-7 |
| CORS | Cross-Origin Resource Sharing | 別のサイトからの呼び出しの許可ルール | 7-2 |
| LAN | Local Area Network | 同じ建物・Wi-Fi 内のネットワーク | 4-3 |
| SHA-256 | Secure Hash Algorithm（256ビット） | ハッシュの計算方法の1つ | 4-8 |
| SVG | Scalable Vector Graphics | 拡大しても荒れない画像 | 7-6 |
