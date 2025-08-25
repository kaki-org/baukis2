# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Rails 8 asset pipeline configuration
# Add webpack builds directory to asset paths for Rails 8 compatibility
Rails.application.config.assets.paths << Rails.root.join('app/assets/builds')

# Rails 8 対応: パックベースアーキテクチャ用の追加アセットをプリコンパイル
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[
  admin.js admin.css
  staff.js staff.css
  customer.js customer.css
  application.js
]

# Rails 8 対応: SCSS ファイルのプリコンパイル設定
Rails.application.config.assets.precompile += %w[
  admin.scss
  staff.scss
  customer.scss
]

# Rails 8 performance optimization for asset pipeline
Rails.application.config.assets.configure do |env|
  env.export_concurrent = false if Rails.env.development?
end
