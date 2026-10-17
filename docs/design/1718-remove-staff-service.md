# StaffService を廃止し、staff から customer のモデルを直接参照する (#1718)

## 結論
staff パックから `Customer` / `Address` を定数で直接参照し、`StaffService` を削除する。
Issue の完了条件は #1732（Customer / Address の公開）と #1773（app.yml + constantize の削除）で満たされたが、レジストリによる間接参照が残っている。差し替えの要件はないので、依存を宣言済みの staff → customer は直接参照で表す（Issue の案 A）。

## 設計
- `StaffService.customer` → `Customer`、`StaffService.address` → `Address` に置き換える（controller・form・view・request spec）
- `packs/staff/app/services/staff_service.rb` と、initializer の `StaffService.configure(Customer, Address)` を削除する
- `packs/CLAUDE.md` のレジストリの節を、「依存を宣言でき、相手が公開している場合は定数で直接参照する。レジストリは AdminService だけ」と書き直す

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| StaffService を残す（Issue をクローズのみ） | 依存はすでに packwerk から見えており、レジストリは差し替えに使われていない間接参照になる |
| インターフェースを定義し契約テストで担保する（Issue の案 B） | Customer を差し替える要件がない |

## Non-goals
- AdminService の廃止・見直し（admin は AdminService 経由でのみ staff のデータに触れる方針のため残す）
