# CLAUDE.md

このファイルは、このリポジトリのコードを扱う際のClaude Code (claude.ai/code) への指針を提供します。

## プロジェクト概要

Baukis2は、packwerkベースのモジュラーアーキテクチャを採用したRuby on Rails顧客管理システムです。3つの異なるインターフェースがあります：
- スタッフインターフェース: `http://baukis2.lvh.me:23000/`
- 管理者インターフェース: `http://baukis2.lvh.me:23000/admin`
- 顧客インターフェース: `http://lvh.me:23000/mypage`

## アーキテクチャ

### Packwerk構造
コードベースはPackwerkを使用してモジュラーの境界を強制します：
- `/packs/staff/` - スタッフ機能
- `/packs/admin/` - 管理機能
- `/packs/customer/` - 顧客向け機能

各パックは独自のMVC構造、ルート、テストを含み、`package.yml`で定義された依存関係が強制されます。

### 主要パターン
- **Form Objects**: 複雑なバリデーション（例：`Staff::LoginForm`）
- **Presenters**: ビューロジックの分離（例：`StaffMemberPresenter`）
- **Service Objects**: ビジネスロジックのカプセル化（例：`Staff::Authenticator`）
- **Concerns**: 共有機能（`EmailHolder`、`PasswordHolder`など）

## 開発コマンド

### セットアップとサーバー
```bash
dip provision          # 初期セットアップ
dip rails db:migrate   # マイグレーション実行
dip rails db:seed      # データベースシード
dip rails s            # サーバー開始
```

### テスト
```bash
dip rspec                           # 全テスト実行
dip rspec spec/path/to/test_spec.rb # 特定のテスト実行
```

### コード品質
```bash
dip rubocop        # リンティング実行
dip rubocop -a     # 問題の自動修正
dip brakeman       # セキュリティ分析
```

### パッケージ管理
```bash
dip bundle install  # Ruby依存関係
dip pnpm install    # JavaScript依存関係
dip pnpm build      # JavaScriptビルド
```

## 技術スタック
- Ruby 4.0.0, Rails 8.0.0
- PostgreSQL 17
- Stimulus, Turbo Rails, Webpack
- テスト用RSpec with Capybara/Playwright
- オーケストレーション用Docker with dip

## ファイル構成
- パックルート: `/packs/*/config/routes/*.rb`
- 共有ビュー: `/app/views/shared/`
- レイアウト: `/app/views/layouts/`（各インターフェース別）
- シード: `/packs/*/db/seeds/development/`
- ロケール: `/config/locales/`（日本語がデフォルト）

## テスト構造
テストは各パックの`spec/`ディレクトリ内に配置されます。RSpec、FactoryBot、Playwrightドライバーによるシステムテストを使用します。
