# PostgreSQL の readiness を Compose の healthcheck で保証する (#1745)

## 結論
`db` に TCP 経由の `pg_isready` で判定する healthcheck を定義し、`web` の `depends_on` を `condition: service_healthy` にする。`docker compose run` も依存サービスの healthy を待つので、待機は Compose の設定 1 か所で済み、各ドキュメントの手順は変えなくてよい。DB が healthy にならないときは run が失敗し、`docker compose logs db` で原因を確認できる。

## 設計
```yaml
db:
  healthcheck:
    test: ["CMD", "pg_isready", "-h", "127.0.0.1", "-U", "postgres"]
    interval: 5s
    timeout: 3s
    retries: 5
    start_period: 60s
    start_interval: 1s
web:
  depends_on:
    db:
      condition: service_healthy
```

- **`-h 127.0.0.1` で TCP を指定する理由**: postgres イメージは初期化中、`listen_addresses=''` の一時サーバを UNIX ソケットだけで起動し（`docker-entrypoint.sh:297`）、initdb の後にいったん停止してから本起動する。ソケットで判定すると、この一時サーバに対して ready を返しうる。init スクリプトがない現状では一時サーバの期間が短く、検証では観測しなかった。それでも TCP の方が、web と同じ経路で判定できる
- **間隔の設定**: 空ボリュームの初期化を `start_period` の 60 秒で吸収する。その間は `start_interval` の 1 秒ごとに判定するので、通常の起動では待ち時間がほとんど増えない。起動後に応答しなくなった場合は、5 秒間隔 × 5 回で unhealthy にする
- **README の PostgreSQL 18 移行手順**: `until docker compose exec db pg_isready ...; do sleep 1; done` のループを `docker compose up -d --wait db` に置き換える。healthcheck を定義したので、手順側に判定を重複させない

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| 各手順に `until pg_isready` ループを追加する | Issue の方針に反する。ドキュメント 5 か所に同じ処理が重複する |
| `bin/setup` の中で DB 接続をリトライする | Compose 以外の環境にも影響する。`db:prepare` 以外のコマンド（`rspec` など）では待機しない |
| `pg_isready` を UNIX ソケットで判定する（`-h` なし） | 初期化中の一時サーバに ready を返しうる。web は TCP で接続するので、判定も TCP で揃える |

## Non-goals
- `chrome` など、`db` 以外のサービスの readiness
- #1734（ネイティブ拡張のビルド）と #1735（既存 DB ボリュームのマウント位置）
- CI（`ruby.yml` は services の `--health-cmd` で待機済み）
