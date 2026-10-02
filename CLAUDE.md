# CLAUDE.md

Baukis2 は packwerk でモジュラー化された Rails 顧客管理システム。
- スタッフ: http://baukis2.lvh.me:23000/
- 管理者: http://baukis2.lvh.me:23000/admin
- 顧客: http://lvh.me:23000/mypage

## コマンドは全て docker compose run 経由で実行する
Ruby と gem は Docker コンテナ (web サービス) 内にのみ存在するため、ホストで直接 bundle exec を実行すると失敗する。
- テスト: docker compose run --rm -e RAILS_ENV=test web bundle exec rspec [path] (RAILS_ENV=test を必ず付ける)
- lint: docker compose run --rm --no-deps web bundle exec rubocop / 自動修正は末尾に -a
- サーバ: docker compose run --rm --service-ports web bundle exec rails s -b 0.0.0.0 (http://baukis2.lvh.me:23000)
- 依存: docker compose run --rm web bundle install (pnpm install / pnpm build も同様に web の後ろに書く)
- DB: docker compose run --rm web bundle exec rails db:migrate (db:seed も同様)
- 初期セットアップ: docker compose down --volumes && docker compose up -d db && docker compose run --rm web ./bin/setup --skip-server (既存 DB を消す)

## packwerk 境界
全パックが enforce_dependencies / enforce_privacy: true。既存違反は各パックの package_todo.yml に猶予登録されているだけで、新規のパック外定数参照は CI (danger-packwerk) で検出される。新規コードで package_todo.yml に頼らない。パック間参照の正しい方法は packs/CLAUDE.md を参照。

## 技術スタック
Ruby 4.0.0 / Rails 8.1 / PostgreSQL 18 / RSpec + Capybara (Playwright) / webpack + pnpm (Shakapacker 不使用) / Stimulus。i18n デフォルトは ja、タイムゾーンは Tokyo。
