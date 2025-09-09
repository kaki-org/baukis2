# frozen_string_literal: true

# トップレベルのdb/seedsディレクトリを探索
Rails.root.glob("db/seeds/#{Rails.env}/*.rb").each do |seed_file|
  Rails.logger.debug { "Loading seed file: #{File.basename(seed_file)}" }
  load seed_file
end

# 各Pack内のdb/seedsディレクトリを探索
Rails.root.glob("packs/*/db/seeds/#{Rails.env}/*.rb").each do |seed_file|
  pack_name = seed_file.split('/')[-5]
  Rails.logger.debug { "Loading seed file from pack: #{pack_name}/#{File.basename(seed_file)}" }
  load seed_file
end
