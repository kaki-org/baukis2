# Junie利用のガイドライン

## ルール

- 回答は全て日本語で行うこと
- プランニングの過程も日本語で出力すること

## Baukis2 開発ガイドライン


このドキュメントは、Baukis2プロジェクトに取り組む開発者向けのガイドラインと情報を提供します。

### ビルド/設定手順

#### システム要件
- Ruby 3.4.4
- PostgreSQL 17
- 開発環境管理用の [dip](https://github.com/bibendi/dip/tree/v5.0.0#installation)

#### セットアッププロセス
1. https://github.com/bibendi/dip/tree/v5.0.0#installation の手順に従って dip をインストールします
2. 開発環境をセットアップします：
   ```bash
   dip provision
   dip rails db:migrate
   dip rails db:seed
   ```
3. サーバーを起動します：
   ```bash
   dip rails s
   ```

#### アクセスURL
- スタッフ画面: http://baukis2.lvh.me:23000/
- 管理者画面: http://baukis2.lvh.me:23000/admin
- 顧客画面: http://lvh.me:23000/mypage

#### データベースのリセット
データベースをリセットしてシードデータを再読み込みするには：
```bash
dip rails db:reset
```

### テスト情報

#### テストの実行
すべてのテストを実行するには：
```bash
dip rspec
```

特定のテストファイルを実行するには：
```bash
dip rspec path/to/spec_file.rb
```

#### テスト構造
このプロジェクトはRSpecをテストに使用しており、以下のような構成になっています：
- `spec/` - アプリケーション全体のテスト用のメインディレクトリ
- `packs/*/spec/` - 各パック（admin、staff、customer）に特化したテスト

#### テストの種類
- **ユニットテスト**: 個々のコンポーネント（モデル、プレゼンター、ヘルパー）をテスト
- **コントローラーテスト**: コントローラーのアクションとレスポンスをテスト
- **リクエストテスト**: APIエンドポイントをテスト
- **システムテスト**: CapybaraとPlaywrightを使用したエンドツーエンドテスト

#### 新しいテストの追加
1. テストに適切な場所を特定します：
   - パック固有の機能については、そのパックのspecディレクトリにテストを追加
   - アプリケーション全体の機能については、メインのspecディレクトリにテストを追加
2. 作成するテストの種類に応じた既存のパターンに従います
3. テストデータの生成にはFactoryBotを使用します
4. `dip rspec path/to/your_spec.rb`でテストを実行します

### テスト例
以下はモジュールの簡単なテスト例です：

```ruby
# spec/lib/html_builder_spec.rb
require 'rails_helper'

class TestClass
  include HtmlBuilder
end

RSpec.describe HtmlBuilder do
  let(:test_instance) { TestClass.new }

  describe '#markup' do
    it 'builds HTML with a tag and content' do
      html = test_instance.markup(:div, class: 'test') do |doc|
        doc.text 'Hello, world!'
      end

      expect(html).to eq '<div class="test">Hello, world!</div>'
    end
  end
end
```

## 追加の開発情報

### コードスタイル
- プロジェクトはコードスタイルの強制にRuboCopを使用しています
- 設定は`.rubocop.yml`と`.rubocop_todo.yml`にあります
- RuboCopを実行するには`dip rubocop`を使用します

### モジュラーアーキテクチャ
- プロジェクトはモジュラーアーキテクチャの強制にPackwerkを使用しています
- コードは`packs/`ディレクトリ内のパックに整理されています：
  - `admin/` - 管理者インターフェース
  - `staff/` - スタッフインターフェース
  - `customer/` - 顧客インターフェース
- 各パックには独自のモデル、コントローラー、ビュー、テストがあります
- コードを書く際はパック間のプライバシー境界に注意してください

### カバレッジレポート
- コードカバレッジレポートにはSimpleCovが使用されています
- カバレッジレポートはHTMLとLCOV形式で生成されます
- レポートは`coverage/`ディレクトリに保存されます

### デバッグ
データベーステーブルを調査するには：
```ruby
dip rails r StaffMember.columns.each { |c| p [c.name, c.type ] }
```

テスト用にデータを変更するには：
```ruby
dip rails r StaffMember.first.update_columns(suspended: true)
```
