![Build](https://github.com/kakikubo/baukis2/workflows/Build/badge.svg)
[![codecov](https://codecov.io/gh/kakikubo/baukis2/graph/badge.svg?token=ZZ0UOHGQSB)](https://codecov.io/gh/kakikubo/baukis2)

# Baukis2 - 顧客管理システム

## 説明

Baukis2 は企業向けの顧客管理システム(Ruby on Rails 学習用サンプル)です。

## 推奨されるシステム環境

* Ubuntu 22.04
* Ruby 3.4.2
* PostgreSQL 17

# 必要なシステム

* dip
  * <https://github.com/bibendi/dip/tree/v5.0.0#installation>

# セットアップ

書籍とちがってdip使うことにしてます。

```bash
dip provision
dip rails db:migrate
dip rails db:seed
dip rails s
```

などとして起動します
最初からデータを入れ直すときは

```bash
dip rails db:reset
```

## URLアクセス

* <http://baukis2.lvh.me:23000/> (staffです)
* <http://baukis2.lvh.me:23000/admin>
* <http://lvh.me:23000/mypage>

## テスト

```bash
dip rspec
```

## テーブルがどのようなカラムをもっているか調べる

```ruby
dip rails r StaffMember.columns.each { |c| p [c.name, c.type ] }
```

## アカウントをサスペンドするとか

```ruby
dip rails r StaffMember.first.update_columns(suspended: true)
```
