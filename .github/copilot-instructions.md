# Copilot 利用ガイド

このリポジトリは Ruby on Rails 学習用サンプル「Baukis2」（顧客管理システム）です。

## 推奨設定
- 拡張機能: [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- 推奨エディタ: VS Code

## システム要件・セットアップ
- Ubuntu 22.04
- Ruby 4.0.0
- PostgreSQL 17
- Docker（Docker Compose v2）

セットアップ例:
```bash
docker compose up -d db
docker compose run --rm web ./bin/setup --skip-server
docker compose run --rm web bundle exec rails db:migrate
docker compose run --rm web bundle exec rails db:seed
docker compose run --rm --service-ports web bundle exec rails s -b 0.0.0.0
```

テスト実行:
```bash
docker compose run --rm -e RAILS_ENV=test web bundle exec rspec
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
