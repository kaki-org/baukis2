# Copilot 利用ガイド

このリポジトリは Ruby on Rails 学習用サンプル「Baukis2」（顧客管理システム）です。

## 推奨設定
- 拡張機能: [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- 推奨エディタ: VS Code

## システム要件・セットアップ
- Ubuntu 22.04
- Ruby 3.4.4
- PostgreSQL 17
- dip（開発環境支援ツール）

セットアップ例:
```bash
dip provision
dip rails db:migrate
dip rails db:seed
dip rails s
```

テスト実行:
```bash
dip rspec
```

## 利用上の注意
- 生成されたコードは必ず内容を確認し、必要に応じて修正してください。
- 機密情報や個人情報を含むコードの自動生成は避けてください。
- 著作権やライセンスに注意してください。

## 参考リンク
- [GitHub Copilot 公式ドキュメント](https://docs.github.com/ja/copilot)
- [Copilot 利用規約](https://github.com/features/copilot/terms)

---

このファイルはプロジェクトメンバー向けの Copilot 利用ガイドです。
