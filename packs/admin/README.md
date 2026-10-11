# packs/admin

管理者向け product パック（`layer: product`）。管理者 UI と、AdminService 経由でのスタッフ管理を持つ。

## 公開 API
他パック向けの公開定数はない。スタッフデータは `AdminService.staff_member` / `AdminService.staff_event` 経由でのみ扱う。

## 依存・可視性
- 依存: `.`（公開された `AdminService`）、`packs/shared`
- `enforce_visibility: true`、`visible_to: []`

## Owner
`metadata.owner: kaki-org`
