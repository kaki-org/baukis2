# frozen_string_literal: true

# ref: https://danger.systems/reference.html

# Danger gem動作確認用(意図的にコメントさせたい場合はコメントインする)
# warn("Danger gem動作確認用")

# 違反でビルドを落とすのは ruby.yml の packwerk ジョブ。ここでは行コメントだけ付ける
# 既定の formatter は layer / visibility 違反も privacy と表示するので、コメント対象は既定の dependency / privacy のままにする
packwerk.check

# package_todo_yml_changes.check の行コメントは使わない。下のラチェットが同じ追加を一覧付きで fail にするうえ、
# その formatter は owner チームに slack.room_for_humans を要求し、未設定だと例外で落ちる

# update-todo で package_todo.yml に違反を足すと packwerk check が通ってしまうので、追加を拒否する (削除は許可)
added_todo_violations = DangerPackwerk::DangerPackageTodoYmlChanges.get_violation_diff(
  %w[dependency privacy layer visibility], git: git
).added_violations
if added_todo_violations.any?
  list = added_todo_violations.map do |v|
    "- #{v.type}: `#{v.class_name}` (#{v.file}, #{v.from_package_name} -> #{v.to_package_name})"
  end
  # Danger の fail の別名。Kernel#fail と紛れて rubocop の Style/SignalException に掛かるのを避ける
  failure("package_todo.yml に packwerk 違反が追加されています。猶予登録せずに違反を解消してください。\n#{list.join("\n")}")
end
