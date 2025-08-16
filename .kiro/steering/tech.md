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
- **Dip**: Dockerベースの開発環境オーケストレーション
- **Docker**: コンテナ化された開発セットアップ
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
dip provision              # 初期セットアップ
dip rails db:migrate      # データベースマイグレーション実行
dip rails db:seed         # サンプルデータでデータベースをシード
dip rails s               # 開発サーバー起動
```

### テスト
```bash
dip rspec                 # 全テスト実行
dip rspec spec/path/      # 特定のテストディレクトリ実行
```

### コード品質
```bash
dip rubocop               # Rubyリンティング実行
dip brakeman              # セキュリティ分析
```

### データベース操作
```bash
dip rails db:reset        # データベースリセット（削除、作成、マイグレート、シード）
dip rails r "Model.method" # Railsコンソールコマンド実行
```

### アセット管理
```bash
dip pnpm install          # Node.js依存関係インストール
dip pnpm run build        # フロントエンドアセットビルド
```

## 開発URL
- スタッフインターフェース: http://baukis2.lvh.me:23000/
- 管理者インターフェース: http://baukis2.lvh.me:23000/admin
- 顧客インターフェース: http://lvh.me:23000/mypage