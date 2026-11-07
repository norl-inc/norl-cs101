#!/bin/bash
command -v docker >/dev/null || { echo "NG: docker がインストールされていません。Docker Desktop か OrbStack を入れて、起動してください"; exit 1; }
docker info >/dev/null 2>&1 || { echo "NG: Docker は入っていますが起動していません。Docker Desktop / OrbStack のアプリを開いて、少し待ってからもう一度どうぞ"; exit 1; }
docker image inspect hello-world >/dev/null 2>&1 || { echo "NG: hello-world がまだ手元にありません（docker run hello-world）"; exit 1; }
docker image inspect nginx >/dev/null 2>&1 || { echo "NG: nginx がまだ手元にありません（docker run -d --name web -p 8080:80 nginx）"; exit 1; }
echo "OK: hello-world と nginx を動かした形跡があります"
