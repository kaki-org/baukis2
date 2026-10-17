# packwerk: CI で validate / check を実行し新規違反でビルドを失敗させる (#1719)

## 結論
- `ruby.yml` に独立ジョブ `packwerk` を追加し、`bin/packwerk validate` → `bin/packwerk check` を実行する。新規違反のゲートはこのジョブ
- Danger の `packwerk.check` / `package_todo_yml_changes.check` は既定のまま行コメントだけ担う（`fail_build` 既定 false）
- `package_todo.yml` に違反を追加する差分は Danger が `failure` にする（ラチェット。削除は許可）

## 背景
danger-packwerk の `packwerk.check` は既定 `fail_build: false` でコメントのみ。既定の `violation_types` は dependency / privacy だけで、#1720 の layer / visibility 違反は対象外だった。`bin/packwerk update-todo` で猶予登録すれば `packwerk check` 自体は通る。

## 代替案
| 案 | 却下理由 |
|---|---|
| rspec_job のステップに追加 | DB・アセット準備を待つため結果が遅い。packwerk は DB 不要なので独立ジョブで並列に回す |
| Danger の `fail_build: true` をゲートにする | danger.yml は master 向け PR を除外し、変更ファイルしか見ない。ゲートジョブと二重に失敗する |
| Danger の `violation_types` に layer / visibility を追加 | 既定 formatter が dependency 以外を privacy として案内するため誤誘導になる。ゲートジョブの packwerk 出力が正確 |
| ラチェットを package_todo.yml の行数比較スクリプトで書く | base との差分処理を自作することになる。danger-packwerk の `get_violation_diff` が違反単位の差分を返す |
| package_todo.yml の存在自体を禁止 | 現状 0 件なので成立するが、違反を減らす途中の差分も拒否してしまう |

## 検証
- probe ファイル (customer → StaffMember 参照) で `bin/packwerk check` が 4 件 (dependency / privacy / layer / visibility) を検出し exit 1
- `update-todo` 後は `packwerk check` が exit 0 になり、ラチェット (`danger dry_run`) が 4 件を列挙して exit 1。逆方向 (削除) の差分では exit 0
