# packs 共通規約

packs/staff・packs/admin・packs/customer は packwerk パック。各パックが app / config/routes / spec / db/seeds を内包する。パック横断で共有されるコード (model concerns、Presenter 基底クラス、AdminService) だけがルートの app/ に置かれる。

## 名前空間は層で使い分ける
コントローラ・Form Object・Authenticator は Staff:: / Admin:: 名前空間 (packs/staff/app/forms/staff/login_form.rb → Staff::LoginForm)。モデルと Presenter はトップレベル (packs/staff/app/models/staff_member.rb → StaffMember。staff サブディレクトリなし)。パック内だからといってモデルに Staff:: を付けると別定数になり、既存コードと繋がらない。

## 他パックのモデルは Service レジストリ経由で参照する
StaffService.customer / AdminService.staff_member のように、initializer で登録されたレジストリからクラスを取得する。他パックのモデルを裸の定数で書くと packwerk の新規違反になる (関連名のシンボルや class_name の文字列は検出対象外)。レジストリ本体: packs/staff/app/services/staff_service.rb と app/services/admin_service.rb。登録処理: packs/*/config/initializers/configure_*.rb。

## 公開 API は pack_public sigil で宣言する
他パックに公開するファイルは 1 行目に `# pack_public: true` を置く (frozen_string_literal より前。packwerk-extensions は先頭 5 行しか見ず、後ろに置くと rubocop の Layout/EmptyLineAfterMagicComment に掛かる)。app/public/ への移動はしない。現在の公開 API は customer パックの Customer / Address / Phone / CustomerPresenter / CustomerFormPresenter のみで、customer パックの公開一覧は spec/packwerk/rails8_compatibility_spec.rb で固定している (公開を増減するときは spec も更新する。他パックで公開を始めるときは同様の検証を足す)。公開されていても依存宣言 (package.yml) のないパックからの参照は dependency 違反になる。StaffService は customer → staff の逆依存 (#1717) の産物なので公開しない。

## 依存関係 (package.yml)
staff は customer と root (.) に依存できる。admin と customer は依存宣言なし: admin は AdminService 経由でのみ staff のデータに触れる。customer は依存される側のリーフで、他パックへの依存を追加しない。

## ルーティング
新ルートは対象パックの packs/*/config/routes/*.rb に手で書く。generator は skip_routes 設定 (config/application.rb) のためルートを自動追記しない。ホスト分離 (staff/admin: baukis2.lvh.me、customer: lvh.me) は各 routes ファイルの constraints host: が担い、設定値は config/initializers/baukis2.rb にある。

## type カラムの意味は2通りある
Address (customer パック) は本物の STI 親 (HomeAddress / WorkAddress が継承)。StaffEvent (staff パック) は self.inheritance_column = nil で STI を無効化し、type は 'logged_in' 等の生の文字列カラム。type カラムを見て一律に STI と判断しない。

## テストと seeds
新規テストと factory は対象パック内の spec/ に置き、既存の類似 spec を手本にする。システムテストのドライバはデフォルト :rack_test で、:js と :system の両メタデータを持つ example だけが :playwright で動く (spec/rails_helper.rb。type: :system は spec/system 配下で自動付与されるため、実際には :js タグを足せばよい)。seeds は packs/<パック>/db/seeds/<環境名>/*.rb に置く (db/seeds.rb が環境ごとに glob ロード)。
