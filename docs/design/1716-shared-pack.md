# ルート app/ の共有カーネルを packs/shared に切り出す (#1716)

## 結論
モデル基底・concern・Presenter 基底・ApplicationController を依存ゼロの `packs/shared` に移し、`# pack_public: true` で公開して admin / customer / staff / root が `packs/shared` に依存する。
Address 専用の Presenter 2 つは共有カーネルではないため customer パックに移す（staff は既に customer に依存している）。
AdminService は admin↔staff の連携用で、共有カーネルではないため今回は移さない。

## 設計
| 移動先 | 対象 | 公開 |
|---|---|---|
| packs/shared | ApplicationRecord, EmailHolder, PasswordHolder, PersonalNameHolder, StringNormalizer | 公開 |
| packs/shared | ModelPresenter, FormPresenter, UserFormPresenter, HtmlBuilder | 公開 |
| packs/shared | ApplicationController（Forbidden / IpAddressRejected を含む） | 公開 |
| packs/shared | ErrorHandlers | 非公開（ApplicationController からのみ使う） |
| packs/customer | AddressPresenter, AddressFormPresenter | 公開 |

- HtmlBuilder はルートの ApplicationHelper から参照されるため公開する
- 依存関係は次のとおり。shared は何にも依存しない。customer は「shared 以外に依存しないリーフ」とする
  - admin / customer → shared
  - staff → shared, customer, `.`（`.` は AdminService 参照のため残す）
  - root → shared, customer
- ルートに残すもの: ErrorsController、ApplicationHelper / Job / Mailer、channels、layouts・errors・kaminari のビュー、assets、AdminService
- 移したコードの spec（model_presenter / user_form_presenter / html_builder / dummy_controllers / address_presenter*）は移動先パックの spec/ に移す
- `spec/packwerk/rails8_compatibility_spec.rb` を更新する
  - shared の公開一覧の固定を追加する
  - customer の公開一覧に Address の Presenter 2 つを追加する
  - enforce の検証対象に shared を追加する
- `packs/CLAUDE.md` の依存関係・公開 API の記述を更新する

移行後の package_todo.yml には AdminService（admin / staff）と StaffService（customer → staff, #1717）の 3 系統だけが残る。

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| 各パックが root (`.`) への依存を宣言する | root はルーティングや初期化を担い、customer を参照する。そのため customer→root→customer の循環になり、privacy 違反も残る |
| Address の Presenter も shared に置く | ドメイン固有のコードがカーネルに混ざる。依存先の customer に置けば staff の参照は解消できる |
| AdminService も shared に移す | admin と staff の連携のための仕組みで、カーネルではない。StaffService (#1717) と同じく別 Issue で扱う |
| `app/public/` で公開する | packs/CLAUDE.md の規約（sigil で宣言する）に反する |

## Non-goals
- AdminService / StaffService 由来の todo 解消
- layouts・errors ビュー・assets の移動
- ErrorsController のパック化
