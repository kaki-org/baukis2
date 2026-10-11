# packs/staff

スタッフ向け product パック（`layer: product`）。StaffMember / StaffEvent とスタッフ UI を持つ。

## 公開 API
他パック向けの公開定数はない。admin がスタッフデータに触れるときは root の `AdminService` 経由にする（このパックのモデルを直接参照しない）。

## 依存・可視性
- 依存: `.`（AdminService）、`packs/customer`、`packs/shared`
- `enforce_visibility: true`、`visible_to: []`。どのパックからも直接参照できない

## Owner
`metadata.owner: kaki-org`
