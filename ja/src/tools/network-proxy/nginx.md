# Nginx

<!-- toc -->

- [リバースプロキシ](#リバースプロキシ)
- [`$connection_upgrade` の定義例](#connection_upgrade-の定義例)

<!-- /toc -->

## リバースプロキシ

**設定例**:

```nginx

map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

location /subpath { return 301 /subpath/; }

location /subpath/ {
    client_max_body_size 512m;
    proxy_pass         http://upstream:3000/;
    proxy_http_version 1.1;
    proxy_redirect     off;

    proxy_set_header Host               $host;
    proxy_set_header X-Real-IP          $remote_addr;
    proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto  $scheme;
    proxy_set_header X-Forwarded-Prefix /subpath;

    proxy_set_header Upgrade            $http_upgrade;
    proxy_set_header Connection         $connection_upgrade;

    proxy_read_timeout  3600s;
    proxy_send_timeout  3600s;
}
```

**リバースプロキシ設定のディレクティブ一覧**:

| オプション                            | 意味 / 役割                                   | 設定例                                                         | 備考 / 注意点                                        |
| ------------------------------------- | --------------------------------------------- | -------------------------------------------------------------- | ---------------------------------------------------- |
| `client_max_body_size`                | クライアントのリクエストボディ最大サイズ      | `client_max_body_size 512m;`                                   | 大きなアップロード / LFS を想定して拡張（既定は1MB） |
| `proxy_pass`                          | バックエンド転送先（Docker 内の上流）         | `proxy_pass http://upstream:3000/;`                            | 末尾 `/` があると `/subpath/` を剥がして `/` に渡す  |
| `proxy_http_version`                  | 上流への HTTP バージョン                      | `proxy_http_version 1.1;`                                      | WebSocket / SSE に必須（既定は 1.0）                 |
| `proxy_redirect`                      | 上流の `Location` 書き換え制御                | `proxy_redirect off;`                                          | `ROOT_URL` 等が正しければオフ推奨                    |
| `proxy_set_header Host`               | 元のホスト名を上流へ伝達                      | `proxy_set_header Host $host;`                                 | URL 生成や CSRF 判定で使用                           |
| `proxy_set_header X-Real-IP`          | クライアント実 IP（単一）                     | `proxy_set_header X-Real-IP $remote_addr;`                     | アクセスログ/制御用                                  |
| `proxy_set_header X-Forwarded-For`    | 経由 IP の連結チェーン                        | `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` | LB/多段プロキシで重要                                |
| `proxy_set_header X-Forwarded-Proto`  | クライアント側のスキーム                      | `proxy_set_header X-Forwarded-Proto $scheme;`                  | リダイレクト / 絶対URL生成で使用                     |
| `proxy_set_header X-Forwarded-Prefix` | サブパスのベース名                            | `proxy_set_header X-Forwarded-Prefix /subpath;`                | 末尾スラッシュなしが慣例（アプリ側で補完される）     |
| `proxy_set_header Upgrade`            | WebSocket の Upgrade ヘッダ                   | `proxy_set_header Upgrade $http_upgrade;`                      | WS を使う機能に必要                                  |
| `proxy_set_header Connection`         | WebSocket 用の接続指示                        | `proxy_set_header Connection $connection_upgrade;`             | `$connection_upgrade` は `map` で定義が必要          |
| `proxy_read_timeout`                  | 上流レスポンス待機の上限                      | `proxy_read_timeout 3600s;`                                    | 長時間処理（大容量 push 等）で切断防止               |
| `proxy_send_timeout`                  | 上流への送信完了までの上限                    | `proxy_send_timeout 3600s;`                                    | 大容量アップロードで有効                             |
| `proxy_buffering`                     | 上流レスポンスのバッファリング                | `proxy_buffering off;`                                         | SSE/ストリーミングで即時性を優先                     |
| `proxy_request_buffering`             | クライアント→Nginx のリクエストバッファリング | `proxy_request_buffering off;`                                 | 大容量 POST を逐次転送したい場合                     |

---

## `$connection_upgrade` の定義例

```nginx
http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }
    ...
}
```
