# customer パックをリーフにする (#1717)

## 結論
`StaffService.configure` は、レジストリを使う側の staff パックの initializer で呼ぶ。customer パックの initializer は削除し、customer → staff の依存をなくす。
ルートから customer への定数参照は spec の 1 箇所だけなので、それを customer パックの spec に移す。そのうえでルート package.yml から `packs/customer` への依存を外す。
これで customer は shared にしか依存しないリーフになり、package_todo.yml から StaffService の項目が消える。

## 設計
- `packs/staff/config/initializers/configure_staff.rb` で `StaffService.configure(Customer, Address)` を呼ぶ
  - staff は customer に依存を宣言しており、Customer / Address は pack_public なので、違反にならない
  - `AdminService.configure(StaffMember, StaffEvent)` と同じく、クラスは定数で直接渡す
- `config/app.yml` の `customer_class` / `address_class` と、それを読む `config.app = config_for(:app)` を削除する
  - これは customer パックから staff の定数を参照しないために、クラス名を文字列で渡していた設定。参照元が staff パックに移ると不要になる。ほかに使っている箇所はない
- `spec/packwerk/rails8_compatibility_spec.rb` を次のように変更する
  - `defined?(Customer)` の検証を `packs/customer/spec` に移す（customer パックの中なら違反にならない）
  - ルートが `packs/customer` に依存しないこと、customer の依存が `packs/shared` だけであることを確認する
- `packs/CLAUDE.md` の、登録処理の置き場所と、依存関係・StaffService の記述を更新する

## 検討した代替案
| 案 | 却下理由 |
|---|---|
| ルートの `config/initializers` で configure する | ルートが staff に依存することになり、逆向きの依存がまた増える |
| StaffService を pack_public にし、customer → staff への依存を宣言する | 違反を正当化するだけで、customer がリーフにならない |
| app.yml の constantize を残して staff 側に移す | staff は customer の定数を直接参照できるため、文字列で間接参照する理由がない |
| ルートの spec で `Object.const_defined?('Customer')` のように文字列で確認する | packwerk の検出を避けているだけで、依存は実際には残っている |

## Non-goals
- AdminService 由来の todo（admin → root、staff → root の privacy）の解消
- `spec/support/database_tests` が文字列の constantize で customer のモデルを参照している箇所（packwerk の検出対象外で、DB の確認用のサポートコード）
