# CLAUDE.md

Baukis2 は packwerk でモジュラー化された Rails 顧客管理システム。
- スタッフ: http://baukis2.lvh.me:23000/
- 管理者: http://baukis2.lvh.me:23000/admin
- 顧客: http://lvh.me:23000/mypage

## コマンドは全て dip 経由で実行する
Ruby と gem は Docker コンテナ内にのみ存在するため、ホストで直接 bundle exec を実行すると失敗する。
- テスト: dip rspec [path] (RAILS_ENV=test は自動設定される)
- lint: dip rubocop / 自動修正 dip rubocop -a
- サーバ: dip rails s (http://baukis2.lvh.me:23000)
- 依存: dip bundle install / dip pnpm install / dip pnpm build
- DB: dip rails db:migrate / dip rails db:seed
- 初期セットアップ: dip provision

## packwerk 境界
全パックが enforce_dependencies / enforce_privacy: true。既存違反は各パックの package_todo.yml に猶予登録されているだけで、新規のパック外定数参照は CI (danger-packwerk) で検出される。新規コードで package_todo.yml に頼らない。パック間参照の正しい方法は packs/CLAUDE.md を参照。

## 技術スタック
Ruby 4.0.0 / Rails 8.1 / PostgreSQL 18 / RSpec + Capybara (Playwright) / webpack + pnpm (Shakapacker 不使用) / Stimulus。i18n デフォルトは ja、タイムゾーンは Tokyo。
