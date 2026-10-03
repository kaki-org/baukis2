# frozen_string_literal: true

# packs/*/db/seeds/... の Pathname からパック名を取り出す。
# Rails.root.glob は Pathname を返すため、String#split 前提の実装に戻ると
# ArgumentError になる（#1736）。抽出処理はここに集約する。
module SeedPack
  module_function

  def name_for(seed_file)
    seed_file.relative_path_from(Rails.root.join('packs')).each_filename.first
  end
end
