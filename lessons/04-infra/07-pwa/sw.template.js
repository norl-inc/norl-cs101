// Service Worker：ページのファイルを端末に保存して、通信が無くても返す係

// TODO: 保存場所の名前を決める（例: "my-site-v1"）。中身を変えたら v2, v3 と変える
const CACHE = "TODO";

// 保存しておくファイル。足りないもの（CSS、画像など）があればここに足す
const FILES = ["./", "./index.html", "./manifest.json"];

// 1) インストール時：ファイルを保存する
self.addEventListener("install", (event) => {
  event.waitUntil(caches.open(CACHE).then((cache) => cache.addAll(FILES)));
});

// 2) 古い保存場所を片付ける
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    )
  );
});

// 3) リクエストが来たら：保存があればそれを返し、無ければ通信する
self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((saved) => saved || fetch(event.request))
  );
});
