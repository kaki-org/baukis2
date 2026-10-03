# GEMINI.md - baukis2 プロジェクト指針

このファイルは、Gemini CLI がこのリポジトリ（baukis2）で作業を行う際の、プロジェクト固有の動作指針および技術スタックの定義です。

## 1. プロジェクト概要
Baukis2 は、書籍『Ruby on Rails 6 実践ガイド』をベースに、最新の技術スタック（Ruby 4.0 / Rails 8.1）と **Packwerk** によるモジュラーアーキテクチャを採用した顧客管理システムです。

- **3つのインターフェース**:
  - スタッフ (`/`)
  - 管理者 (`/admin`)
  - 顧客 (`/mypage`)
- **アーキテクチャ**: Packwerk によるモジュラーモノリス（`/packs` 下に各機能を分離）

## 2. 技術スタック
- **Language/Framework**: Ruby 4.0.0, Rails 8.1.0
- **Database**: PostgreSQL 18.3
- **Frontend**: Stimulus, Turbo Rails, Webpack
- **Infrastructure**: Docker Compose
- **Testing**: RSpec, Capybara, Playwright

## 3. 主要な開発コマンド (docker compose 経由)
Ruby と gem はコンテナ内にのみあるため、コマンドは `docker compose run` で実行してください。

- **セットアップ**: `docker compose down --volumes && docker compose up -d db && docker compose run --rm web ./bin/setup --skip-server`（既存 DB を消します）
- **サーバー起動**: `docker compose run --rm --service-ports web bundle exec rails s -b 0.0.0.0`
- **テスト実行**: `docker compose run --rm -e RAILS_ENV=test web bundle exec rspec`
- **リンター**: `docker compose run --rm --no-deps web bundle exec rubocop`
- **DB操作**: `docker compose run --rm web bundle exec rails db:migrate`, `docker compose run --rm web bundle exec rails db:seed`

## 4. 開発・設計指針
- **モジュール境界の遵守**: `packwerk` の境界を意識し、依存関係（`package.yml`）に違反しないよう実装してください。
- **デザインパターン**:
  - **Form Objects**: 複雑なバリデーションやビジネスロジックの分離。
  - **Presenters**: ビューロジックの整理。
  - **Service Objects**: ビジネスプロセスのカプセル化。
- **UI/UX**: モダンでプレミアムなデザインを追求します。
  - TailwindCSS などの指定がない限り **Vanilla CSS** を優先し、柔軟なデザインを実現してください。
  - 適切な余白、洗練されたタイポグラフィ、ホバーエフェクトなどの動的なインタラクションを重視します。

## 5. 安全・運用ルール（最優先）
以下の操作を行う際は、必要に応じてユーザーの承認を得てください。

1. **破壊的な上書きの禁止と承認要件**: 大規模な変更や自動復旧が困難な既存ファイルの上書きを行う前に、必ず意図を説明し承認を得ること。承認フローが不要な軽微な変更（タイポ修正、コメント追加、新規ファイル作成など）はこの限りではありません。
2. **重要な削除操作は承認必須**: `rm`, `rmdir` 等の削除系コマンドは慎重に扱います。特に、大規模なディレクトリや重要な設定ファイルの削除には事前の承認を必須とします。
3. **パッケージ追加の制限**: `bundle add`, `pnpm add` 等のライブラリ追加は、目的と影響範囲を説明し、承認を得てから実行すること。
4. **非エンジニアへの配慮**: 実行するコマンドが何を行うのか、平易な日本語で説明してから実行すること。

## 6. MCP ツール・外部連携
- **NotebookLM**: リサーチや仕様の深掘りに活用。
- **GitHub**: Issue/PR の自動化、ブランチ管理。
- **Google Sheets**: データ分析や進捗管理に活用。

---
*このファイルはグローバルな GEMINI.md より優先されます。*
