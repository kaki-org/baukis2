# コーディングガイドライン

## コマンド

### git

- かならず`--no-pager`オプションをつけてください。これはページャが起動してタスクを止めない為です

## 言語とコミュニケーション

### 日本語の使用

- **応答**: すべての応答は日本語で行ってください
- **コミットメッセージ**: コミットのタイトルと本文は必ず日本語で記述してください
- **PR タイトル**: プルリクエストのタイトルは日本語で記述してください
- **PR の説明**: プルリクエストの説明文も日本語で記述してください
- **コメント**: コード内のコメントも日本語で記述してください

### コミット戦略

#### 細かい単位でのコミット

- 機能追加や修正は可能な限り小さな単位に分割してコミットしてください
- 1 つのコミットには 1 つの論理的な変更のみを含めてください
- ファイルの種類や機能ごとに分けてコミットすることを推奨します

例：

```bash
# 良い例
git commit -m "Rails 8対応: Gemfileの依存関係を更新"
git commit -m "Rails 8対応: アセットパイプライン設定を追加"
git commit -m "Rails 8対応: Stimulus コントローラーを作成"

# 悪い例
git commit -m "Rails 8対応の全ての変更"
```

#### 長いコミットメッセージの処理

長いコミットログやタイトルを入力する際は、tmp ディレクトリ以下にテンポラリファイルを作成し、そのファイルを引数として使用してください。

**コミットメッセージの場合:**

```bash
# タイトルが長い場合
echo "Rails 8アップグレード: アセットパイプラインとJavaScript設定の更新により、Turbo Rails 8とStimulus 3.2.2の統合を完了" > tmp/commit_title
git commit -F tmp/commit_title

# 本文も含む場合
cat > tmp/commit_message << 'EOF'
Rails 8アップグレード: アセットパイプラインとJavaScript設定の更新

- Turbolinks から Turbo Rails 8 への移行
- Stimulus 3.2.2 の統合とコントローラー作成
- Webpack設定のRails 8対応
- 各パック（admin, staff, customer）のJavaScriptエントリーポイント作成
- アセットパイプライン設定の最適化

要件 2.2, 2.4 を満たす実装
EOF
git commit -F tmp/commit_message
```

**GitHub CLI (gh) コマンドの場合:**

```bash
# PRタイトルが長い場合
echo "Rails 8アップグレード: アセットパイプラインとJavaScript設定の完全な更新" > tmp/title

# PR本文が長い場合
cat > tmp/body << 'EOF'
## 概要
Rails 8へのアップグレードに伴うアセットパイプラインとJavaScript設定の更新

## 変更内容
- Turbolinks から Turbo Rails 8 への移行
- Stimulus コントローラーの実装
- Webpack設定の Rails 8 対応
- 各パックのJavaScriptエントリーポイント作成

## テスト結果
- 開発環境: ✅
- 本番環境: ✅
- テスト環境: ✅

## 関連要件
- 要件 2.2: JavaScript bundling設定更新
- 要件 2.4: アセットパイプライン Rails 8 対応
EOF

# PRを作成
gh pr create -t "$(cat tmp/title)" -b "$(cat tmp/body)"
```

### ファイル管理

#### テンポラリファイルの命名規則

- `tmp/title` - PR やコミットのタイトル用
- `tmp/body` - PR やコミットの本文用
- `tmp/commit_title` - コミットタイトル専用
- `tmp/commit_message` - コミットメッセージ全体用
- `tmp/pr_title` - PR タイトル専用
- `tmp/pr_body` - PR 本文専用

#### テンポラリファイルのクリーンアップ

作業完了後は不要なテンポラリファイルを削除してください：

```bash
rm -f tmp/title tmp/body tmp/commit_* tmp/pr_*
```

## コード品質

### コメントとドキュメント

- 複雑なロジックには日本語でコメントを追加
- 設定ファイルの変更理由を明記
- Rails 8 対応の変更には「Rails 8 対応:」プレフィックスを使用

### 命名規則

- ファイル名: 英語（Rails 規約に従う）
- 変数名: 英語（Rails 規約に従う）
- コメント: 日本語
- コミットメッセージ: 日本語
- PR 関連: 日本語

## 例外事項

以下の場合は英語の使用を許可します：

- コード内の変数名、メソッド名、クラス名
- ファイル名（Rails 規約に従う）
- 技術的な設定ファイルの内容
- 外部ライブラリとの互換性が必要な場合
