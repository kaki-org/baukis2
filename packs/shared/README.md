# packs/shared

共有カーネル。ApplicationRecord / ApplicationController、model concerns、Presenter 基底、HtmlBuilder を提供する最下層（`layer: shared`）のパック。

## 公開 API
`# pack_public: true` で宣言したファイルが公開 API。一覧は `spec/packwerk/rails8_compatibility_spec.rb` で固定している。ErrorHandlers は非公開。

## 依存
他パックに依存しない。全パック（root 含む）から依存される。visibility は掛けず、基盤としてどのパックからも参照できる。

## Owner
`metadata.owner: kaki-org`
