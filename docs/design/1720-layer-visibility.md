# packwerk: layer / visibility チェッカーと owner・README を整備する (#1720)

## 結論
`packwerk.yml` に `layers` を定義し、各パックで `enforce_layers` と `layer` を有効にする。層は上位から `product`（staff / admin / root）> `domain`（customer）> `shared`（shared）。上位 → 下位の依存だけを許可する。
visibility は「誰がどのパックの定数を参照してよいか」を宣言する。staff はどのパックからも直接参照できず、admin は root の `AdminService` 経由でのみ staff のデータに触れる。customer は staff からのみ可視。root（AdminService）は admin / staff からのみ可視。shared は基盤なので visibility を掛けない。
各パックの `package.yml` に `metadata.owner` を付け、テンプレートの `README_TODO.md` を実内容の `README.md` に置き換える。

## 設計
### layers（packwerk.yml）
```yaml
layers:
  - product
  - domain
  - shared
```

| パック | layer | 理由 |
|---|---|---|
| packs/staff, packs/admin, `.`（root） | product | UI / アプリ組み立て。staff は root の AdminService に依存するため root も同層 |
| packs/customer | domain | ドメインモデルのリーフ。product から依存される |
| packs/shared | shared | 共有カーネル。誰からも依存される最下層 |

### visibility
| パック | enforce_visibility | visible_to |
|---|---|---|
| packs/staff | true | （空）admin は StaffMember を直接参照せず AdminService 経由 |
| packs/customer | true | packs/staff |
| `.`（root） | true | packs/admin, packs/staff（AdminService の利用側） |
| packs/admin | true | （空）他パックから参照されない |
| packs/shared | なし | 基盤 API を全パックが使う |

### owner / README
- `metadata.owner: kaki-org` を全パック（root 含む）に付与。`owner` トップレベルキーは packwerk validate の許可キー外のため `metadata` 配下に置く
- 各パックに README.md を置き、役割・公開 API・依存・層を簡潔に記す。`packs/staff/README_TODO.md` は削除する

### CI
danger-packwerk の `packwerk.check` が layer / visibility 違反も検出する（checkers は `packwerk-extensions` 経由で既に require 済み）。新規違反は package_todo.yml に頼らず直す方針は従来どおり。

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| root を shared 層に置く | staff（product）→ root は同層以下なら許されるが、AdminService は共有カーネルではなく product 間連携用。#1716 でも shared に移していない |
| root を product より上の application 層にする | staff が root に依存しているため、上位層への依存（layer 違反）になる |
| staff を admin にも visible にする | 「AdminService 経由でのみ」という規約を壊す |
| `owner` をトップレベルキーにする | packwerk validate が Unknown keys になる。code_ownership を require すれば通るが、本 Issue の範囲外 |
| shared にも enforce_visibility を掛ける | 全パックから使う前提なので可視リストのメンテコストだけ増える |

## AdminService の正当化（本 PR で実施）
visibility で「AdminService 経由」を宣言するだけでは、admin → root の dependency / privacy todo が残る。
ルートの `AdminService` に `# pack_public: true` を付け、admin の `dependencies` に `"."` を追加して todo を解消する。
staff は既に `"."` に依存しているため、pack_public 化だけで privacy todo が消える。

## Non-goals
- code_ownership gem / CODEOWNERS 生成の導入
- folder_privacy チェッカーの導入
