# 技術スタック

## コアフレームワーク・言語
- **Ruby**: 3.4.4
- **Rails**: 8.0.0
- **データベース**: PostgreSQL 17

## フロントエンド技術
- **JavaScript**: Webpackベースのバンドリング
- **CSS**: RailsアセットパイプラインでのSass/SCSS
- **Stimulus**: Rails JavaScriptフレームワーク
- **Turbo/Turbolinks**: SPAライクなナビゲーション
- **jQuery**: レガシーJavaScriptサポート

## アーキテクチャ・モジュール性
- **Packwerk**: 依存関係管理を伴う強制的なモジュラーアーキテクチャ
- **Packs-Rails**: パッケージベースのコード組織化
- **マルチテナント**: 管理者、スタッフ、顧客インターフェース用の個別パック

## 開発ツール
- **Docker Compose**: コンテナ化された開発セットアップ（コマンドは `docker compose run` で実行）
- **pnpm**: Node.js依存関係のパッケージマネージャー

## テスト・品質管理
- **RSpec**: 主要テストフレームワーク
- **Capybara + Playwright**: エンドツーエンドテスト
- **Factory Bot**: テストデータ生成
- **SimpleCov**: コードカバレッジレポート
- **Rubocop**: Rubyコードリンティングとスタイル強制
- **ERB Lint**: ERBテンプレートリンティング

## よく使うコマンド

### 開発セットアップ
```bash
docker compose up -d db && docker compose run --rm web ./bin/setup --skip-server  # 初期セットアップ
docker compose run --rm web bundle exec rails db:migrate   # データベースマイグレーション実行
docker compose run --rm web bundle exec rails db:seed      # サンプルデータでデータベースをシード
docker compose run --rm --service-ports web bundle exec rails s -b 0.0.0.0  # 開発サーバー起動
```

### テスト
```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec             # 全テスト実行
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec spec/path/  # 特定のテストディレクトリ実行
```

### コード品質
```bash
docker compose run --rm --no-deps web bundle exec rubocop  # Rubyリンティング実行
docker compose run --rm web bundle exec brakeman            # セキュリティ分析
```

### データベース操作
```bash
docker compose run --rm web bundle exec rails db:reset          # データベースリセット（削除、作成、マイグレート、シード）
docker compose run --rm web bundle exec rails r "Model.method"  # Railsコンソールコマンド実行
```

### アセット管理
```bash
docker compose run --rm web pnpm install    # Node.js依存関係インストール
docker compose run --rm web pnpm run build  # フロントエンドアセットビルド
```

## 開発URL
- スタッフインターフェース: http://baukis2.lvh.me:23000/
- 管理者インターフェース: http://baukis2.lvh.me:23000/admin
- 顧客インターフェース: http://lvh.me:23000/mypage