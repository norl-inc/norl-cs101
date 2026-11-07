// Service Worker：ブラウザの裏で動く「門番」。画面とネットの間に立って、
// 「これはキャッシュ（手元の保存）から返す？ネットに取りに行く？」を決める。

const CACHE = "memo-v1"; // 画面を変えたら v2, v3 … と上げる（古いキャッシュが居座るのを防ぐ）
const FILES = ["/", "/manifest.json", "/icon.svg"];

// インストール時：必要なファイルをキャッシュに入れておく
self.addEventListener("install", (event) => {
  // TODO 1: caches.open(CACHE) でキャッシュを開いて、FILES を addAll する
  //   event.waitUntil(...) で包むと、終わるまでブラウザが待ってくれる
});

// 新しい門番に入れ替わったとき：古い版の保存場所（memo-v1 など）を片付ける（できあがり）
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))
    )
  );
});

// ファイルを取りに行くたびに呼ばれる
self.addEventListener("fetch", (event) => {
  const url = new URL(event.request.url);

  // API はキャッシュしない（メモはいつも最新を見せたい）
  if (url.pathname.startsWith("/api/")) return;

  // TODO 2: キャッシュにあればそれを、無ければネットに取りに行って返す
  //   event.respondWith( caches.match(event.request).then(...) )
});
