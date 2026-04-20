# Nginx

<!-- toc -->

- [Reverse Proxy](#reverse-proxy)
- [Definition example of `$connection_upgrade`](#definition-example-of-connection_upgrade)

<!-- /toc -->

## Reverse Proxy

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

| オプション                            | 説明                                          | 設定例                                                         | 備考                                                          |
| ------------------------------------- | --------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------- |
| `client_max_body_size`                | クライアントのリクエストボディ最大サイズ      | `client_max_body_size 512m;`                                   | 大きなアップロード / LFS を想定して拡張（既定は 1MB）         |
| `proxy_pass`                          | バックエンド転送先（Docker 内の上流）         | `proxy_pass http://upstream:3000/;`                            | 末尾 `/` があると `/subpath/` を除去して `/` に転送します     |
| `proxy_http_version`                  | 上流への HTTP バージョン                      | `proxy_http_version 1.1;`                                      | WebSocket / SSE に必須です（既定は 1.0）                      |
| `proxy_redirect`                      | 上流の `Location` ヘッダの書き換え制御        | `proxy_redirect off;`                                          | `ROOT_URL` 等が正しければオフを推奨します                     |
| `proxy_set_header Host`               | 元のホスト名を上流へ伝達します                | `proxy_set_header Host $host;`                                 | URL 生成や CSRF 判定で使用されます                            |
| `proxy_set_header X-Real-IP`          | クライアントの実 IP（単一）                   | `proxy_set_header X-Real-IP $remote_addr;`                     | アクセスログ / アクセス制御用です                              |
| `proxy_set_header X-Forwarded-For`    | 経由 IP の連結チェーン                        | `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` | ロードバランサ / 多段プロキシで重要です                       |
| `proxy_set_header X-Forwarded-Proto`  | クライアント側のスキーム                      | `proxy_set_header X-Forwarded-Proto $scheme;`                  | リダイレクト / 絶対 URL 生成で使用されます                    |
| `proxy_set_header X-Forwarded-Prefix` | サブパスのベース名                            | `proxy_set_header X-Forwarded-Prefix /subpath;`                | 末尾スラッシュなしが慣例です（アプリ側で補完されます）        |
| `proxy_set_header Upgrade`            | WebSocket の Upgrade ヘッダ                   | `proxy_set_header Upgrade $http_upgrade;`                      | WebSocket を使用する機能に必要です                            |
| `proxy_set_header Connection`         | WebSocket 用の接続指示                        | `proxy_set_header Connection $connection_upgrade;`             | `$connection_upgrade` は `map` で定義する必要があります        |
| `proxy_read_timeout`                  | 上流レスポンス待機のタイムアウト              | `proxy_read_timeout 3600s;`                                    | 長時間処理（大容量 push 等）での切断を防止します              |
| `proxy_send_timeout`                  | 上流への送信完了までのタイムアウト            | `proxy_send_timeout 3600s;`                                    | 大容量アップロードに有効です                                  |
| `proxy_buffering`                     | 上流レスポンスのバッファリング                | `proxy_buffering off;`                                         | SSE / ストリーミングで即時性を優先します                      |
| `proxy_request_buffering`             | クライアント→Nginx のリクエストバッファリング | `proxy_request_buffering off;`                                 | 大容量 POST をストリーミングで上流へ転送したい場合に使います  |

---

## Definition example of `$connection_upgrade`

```nginx
http {
    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }
    ...
}
```
