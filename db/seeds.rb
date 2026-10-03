# frozen_string_literal: true

# トップレベルのdb/seedsディレクトリを探索
Rails.root.glob("db/seeds/#{Rails.env}/*.rb").each do |seed_file|
  Rails.logger.debug { "Loading seed file: #{seed_file.basename}" }
  load seed_file
end

# 各Pack内のdb/seedsディレクトリを探索
# 同一パック内の依存順はファイル名の数字接頭辞で制御する（例: 01_staff_members → 02_staff_events）
Rails.root.glob("packs/*/db/seeds/#{Rails.env}/*.rb").each do |seed_file|
  pack_name = seed_file.relative_path_from(Rails.root).each_filename.to_a[1]
  Rails.logger.debug { "Loading seed file from pack: #{pack_name}/#{seed_file.basename}" }
  load seed_file
end
