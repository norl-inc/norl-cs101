#!/usr/bin/env python3
# 1秒ごとに playground/app.log へログを書き続ける、レッスン用のプログラム。
# 止めるときは Ctrl+C。
import random
import time
from datetime import datetime
from pathlib import Path

log = Path(__file__).resolve().parents[3] / "playground" / "app.log"
log.parent.mkdir(exist_ok=True)

events = ["INFO  ユーザーがページを開いた", "INFO  天気APIに問い合わせた", "INFO  画面を描いた"]

while True:
    line = random.choice(events)
    if random.random() < 0.15:
        line = "ERROR 天気APIから返事がない"
    with log.open("a") as f:
        f.write(f"{datetime.now():%H:%M:%S} {line}\n")
    time.sleep(1)
