![Build](https://github.com/kakikubo/baukis2/workflows/Build/badge.svg)
[![codecov](https://codecov.io/gh/kakikubo/baukis2/graph/badge.svg?token=ZZ0UOHGQSB)](https://codecov.io/gh/kakikubo/baukis2)

# Baukis2 - 顧客管理システム

## 説明

Baukis2 は企業向けの顧客管理システム(Ruby on Rails 学習用サンプル)です。

## 推奨されるシステム環境

* Ubuntu 22.04
* Ruby 4.0.0
* PostgreSQL 18

# 必要なシステム

* Docker（Docker Compose v2 を含む）

Ruby や gem はコンテナ内にのみあるので、コマンドは `docker compose run` 経由で実行します。

# セットアップ

```bash
docker compose down --volumes
docker compose up -d db
docker compose run --rm web ./bin/setup --skip-server
docker compose run --rm web bundle exec rails db:migrate
docker compose run --rm web bundle exec rails db:seed
docker compose run --rm --service-ports web bundle exec rails s -b 0.0.0.0
```

などとして起動します（最初の 3 行が初期セットアップで、`down --volumes` は既存の DB を消します）。
最初からデータを入れ直すときは

```bash
docker compose run --rm web bundle exec rails db:reset
```

## PostgreSQL 18 への移行（既存の db ボリュームがある場合）

postgres:18 のイメージはデータを `/var/lib/postgresql/18/docker` に置くため、db ボリュームのマウント先を `/var/lib/postgresql/data` から `/var/lib/postgresql` に変更しました。
古いマウント先のまま作られたボリュームでは db コンテナが起動しないので、以下のどちらかで移行してください。
ボリューム名は compose のプロジェクト名（ディレクトリ名）で決まるので、`docker volume ls` で `<プロジェクト名>_db` を確認してから `VOL` に設定します。

```bash
VOL=baukis2_db
docker volume inspect "$VOL" > /dev/null   # 存在しない名前ならここでエラーになる
```

開発用データを捨ててよい場合は、db ボリュームだけ作り直してセットアップし直します。

```bash
docker compose rm -sf db
docker volume rm "$VOL"
docker compose up -d db
docker compose run --rm web ./bin/setup --skip-server
```

データを残したい場合は、旧バージョンでダンプしてから 18 にリストアします。
まず旧データのメジャーバージョンを確認し、`OLD` に設定します（`PG_VERSION` が無ければ旧データは無いので、上の「捨ててよい場合」の手順で構いません）。

```bash
docker run --rm -v "$VOL":/v:ro postgres:18.4-alpine cat /v/PG_VERSION   # 例: 17
OLD=17
```

ダンプはリポジトリの外（`/tmp`）に出力し、最後まで書き出せたことを確認してからボリュームを削除します。

```bash
DUMP=/tmp/baukis2_dump.sql
docker compose rm -sf db
docker run -d --rm --name baukis2-pg-old -e POSTGRES_PASSWORD=secret \
  -v "$VOL":/var/lib/postgresql/data "postgres:${OLD}-alpine"
until docker exec baukis2-pg-old pg_isready -U postgres; do sleep 1; done
docker exec baukis2-pg-old pg_dumpall -U postgres > "$DUMP"
docker stop baukis2-pg-old
# 末尾に完了マーカーがあることを確認する。無ければ先に進まない
grep -q 'PostgreSQL database cluster dump complete' "$DUMP" && echo dump-ok
```

`dump-ok` が表示された場合だけ、続けてリストアします。

```bash
docker volume rm "$VOL"
docker compose up -d db
until docker compose exec db pg_isready -U postgres; do sleep 1; done
docker compose exec -T db psql -U postgres < "$DUMP"
```

リストア時の `ERROR:  role "postgres" already exists` は、18 側に postgres ロールが既にあるためで、無視して問題ありません。それ以外の ERROR が出た場合は、ダンプを残したまま内容を確認してください。
復元を確認できたら、ダンプはパスワードハッシュを含むので削除します。

```bash
rm "$DUMP"
```

## URLアクセス

* <http://baukis2.lvh.me:23000/> (staffです)
* <http://baukis2.lvh.me:23000/admin>
* <http://lvh.me:23000/mypage>

## テスト

```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec [path]
```

## lint

```bash
docker compose run --rm --no-deps web bundle exec rubocop      # 自動修正は -a
docker compose run --rm web bundle exec brakeman
```

## credentials の編集

```bash
docker compose run --rm rails_cred
```

## テーブルがどのようなカラムをもっているか調べる

```bash
docker compose run --rm web bundle exec rails r 'StaffMember.columns.each { |c| p [c.name, c.type ] }'
```

## アカウントをサスペンドするとか

```bash
docker compose run --rm web bundle exec rails r 'StaffMember.first.update_columns(suspended: true)'
```
