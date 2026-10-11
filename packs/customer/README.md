# packs/customer

顧客ドメイン（`layer: domain`）。Customer / Address / Phone と関連 Presenter、顧客向け UI（mypage）を持つリーフパック。

## 公開 API
Customer / Address / Phone と各 Presenter を `# pack_public: true` で公開。一覧は `spec/packwerk/rails8_compatibility_spec.rb` で固定している。

## 依存・可視性
- 依存: `packs/shared` のみ（他パックに依存しない）
- `enforce_visibility: true`、`visible_to: [packs/staff]`。staff 以外からの定数参照は visibility 違反

## Owner
`metadata.owner: kaki-org`
