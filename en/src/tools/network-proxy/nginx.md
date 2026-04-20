# Nginx

<!-- toc -->

- [Reverse Proxy](#reverse-proxy)
- [Definition example of `$connection_upgrade`](#definition-example-of-connection_upgrade)

<!-- /toc -->

## Reverse Proxy

**Configuration example**:

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

**Reverse proxy configuration directives**:

| Option                                | Description                                      | Example                                                        | Notes                                                                     |
| ------------------------------------- | ------------------------------------------------ | -------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `client_max_body_size`                | Maximum size of client request body              | `client_max_body_size 512m;`                                   | Increased for large uploads / LFS (default is 1MB)                        |
| `proxy_pass`                          | Backend destination (upstream within Docker)     | `proxy_pass http://upstream:3000/;`                            | Trailing `/` strips `/subpath/` and forwards to `/`                       |
| `proxy_http_version`                  | HTTP version for upstream                        | `proxy_http_version 1.1;`                                      | Required for WebSocket / SSE (default is 1.0)                             |
| `proxy_redirect`                      | Controls rewriting of upstream `Location` header | `proxy_redirect off;`                                          | Recommended to turn off if `ROOT_URL` etc. are correct                    |
| `proxy_set_header Host`               | Passes original hostname to upstream             | `proxy_set_header Host $host;`                                 | Used for URL generation and CSRF validation                               |
| `proxy_set_header X-Real-IP`          | Client's real IP (single)                        | `proxy_set_header X-Real-IP $remote_addr;`                     | For access logs / access control                                          |
| `proxy_set_header X-Forwarded-For`    | Chained list of IPs along the path               | `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;` | Important for load balancers / multi-tier proxies                         |
| `proxy_set_header X-Forwarded-Proto`  | Client-side scheme                               | `proxy_set_header X-Forwarded-Proto $scheme;`                  | Used for redirects / absolute URL generation                              |
| `proxy_set_header X-Forwarded-Prefix` | Base name of the subpath                         | `proxy_set_header X-Forwarded-Prefix /subpath;`                | Convention is no trailing slash (the application appends it)              |
| `proxy_set_header Upgrade`            | WebSocket Upgrade header                         | `proxy_set_header Upgrade $http_upgrade;`                      | Required for features using WebSocket                                     |
| `proxy_set_header Connection`         | Connection directive for WebSocket               | `proxy_set_header Connection $connection_upgrade;`             | `$connection_upgrade` must be defined via `map`                           |
| `proxy_read_timeout`                  | Timeout for waiting on upstream response         | `proxy_read_timeout 3600s;`                                    | Prevents disconnection during long-running operations (e.g. large pushes) |
| `proxy_send_timeout`                  | Timeout for sending data to upstream             | `proxy_send_timeout 3600s;`                                    | Useful for large uploads                                                  |
| `proxy_buffering`                     | Buffering of upstream responses                  | `proxy_buffering off;`                                         | Prioritizes immediacy for SSE / streaming                                 |
| `proxy_request_buffering`             | Buffering of client-to-Nginx requests            | `proxy_request_buffering off;`                                 | For streaming large POST requests to upstream                             |

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
