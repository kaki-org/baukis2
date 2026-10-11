# packs 共通規約

packs/staff・packs/admin・packs/customer・packs/shared は packwerk パック。各パックが app / config/routes / spec / db/seeds を内包する。パック横断の共有カーネル (ApplicationRecord・ApplicationController・model concerns・Presenter 基底クラス・HtmlBuilder) は packs/shared に置く。ルートの app/ にはアプリの組み立て (ErrorsController・layouts・errors ビュー・assets) と AdminService だけが残る。

## 名前空間は層で使い分ける
コントローラ・Form Object・Authenticator は Staff:: / Admin:: 名前空間 (packs/staff/app/forms/staff/login_form.rb → Staff::LoginForm)。モデルと Presenter はトップレベル (packs/staff/app/models/staff_member.rb → StaffMember。staff サブディレクトリなし)。パック内だからといってモデルに Staff:: を付けると別定数になり、既存コードと繋がらない。

## 他パックのモデルは依存宣言と公開 API を通して参照する
依存を宣言していて (package.yml)、相手が pack_public で公開しているモデルは定数で直接参照する (staff → customer の Customer / Address)。そうでない向きは裸の定数で書くと packwerk の新規違反になる (関連名のシンボルや class_name の文字列は検出対象外)。admin → staff は AdminService.staff_member のように、initializer で登録されたレジストリからクラスを取得する。レジストリ本体は app/services/admin_service.rb。登録処理は、レジストリを使う側が依存先のクラスを渡す形で書く (packs/staff/config/initializers/configure_staff.rb)。依存される側のパックからレジストリに登録すると逆向きの依存になる。

## 公開 API は pack_public sigil で宣言する
他パックに公開するファイルは 1 行目に `# pack_public: true` を置く (frozen_string_literal より前。packwerk-extensions は先頭 5 行しか見ず、後ろに置くと rubocop の Layout/EmptyLineAfterMagicComment に掛かる)。app/public/ への移動はしない。現在の公開 API は customer パック (Customer / Address / Phone と各 Presenter) と shared パック (ErrorHandlers 以外の全ファイル) で、両パックの公開一覧は spec/packwerk/rails8_compatibility_spec.rb で固定している (公開を増減するときは spec も更新する。他パックで公開を始めるときは同様の検証を足す)。公開されていても依存宣言 (package.yml) のないパックからの参照は dependency 違反になる。

## 依存関係 (package.yml)
全パック (root 含む) は packs/shared に依存する。shared は何にも依存しない。root の依存は shared だけで、ルートの app/ と spec/ からパックのドメインモデルを参照しない (パックのモデルを使うテストは各パックの spec/ に置く)。staff は加えて customer と root (.) に依存できる (root は AdminService のため)。admin は AdminService 経由でのみ staff のデータに触れる。customer は依存される側のリーフで、shared 以外への依存を追加しない。

## layer / visibility (packwerk-extensions)
`packwerk.yml` の layers は上位から `product` > `domain` > `shared`。上位 → 同層以下への依存だけが許される。
- product: packs/staff, packs/admin, root (.)
- domain: packs/customer
- shared: packs/shared

visibility は「どのパックから定数参照してよいか」を宣言する。staff は `visible_to: []`（admin は AdminService 経由でのみ触れる）。customer は `visible_to: [packs/staff]`。root は `visible_to: [packs/admin, packs/staff]`（AdminService）。admin は `visible_to: []`。shared は基盤なので enforce_visibility を掛けない。新規の layer / visibility 違反は CI (danger-packwerk) で検出される。

## owner / README
各パックの `package.yml` に `metadata.owner` を置く（トップレベル `owner` は packwerk validate の許可キー外）。パックの説明は各 `packs/*/README.md` に書く。

## ルーティング
新ルートは対象パックの packs/*/config/routes/*.rb に手で書く。generator は skip_routes 設定 (config/application.rb) のためルートを自動追記しない。ホスト分離 (staff/admin: baukis2.lvh.me、customer: lvh.me) は各 routes ファイルの constraints host: が担い、設定値は config/initializers/baukis2.rb にある。

## type カラムの意味は2通りある
Address (customer パック) は本物の STI 親 (HomeAddress / WorkAddress が継承)。StaffEvent (staff パック) は self.inheritance_column = nil で STI を無効化し、type は 'logged_in' 等の生の文字列カラム。type カラムを見て一律に STI と判断しない。

## テストと seeds
新規テストと factory は対象パック内の spec/ に置き、既存の類似 spec を手本にする。システムテストのドライバはデフォルト :rack_test で、:js と :system の両メタデータを持つ example だけが :playwright で動く (spec/rails_helper.rb。type: :system は spec/system 配下で自動付与されるため、実際には :js タグを足せばよい)。seeds は packs/<パック>/db/seeds/<環境名>/*.rb に置く (db/seeds.rb が環境ごとに glob ロード)。
