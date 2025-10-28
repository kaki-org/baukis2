# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.7'
gem 'bundler', '~> 2.7'

gem 'importmap-rails'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 7.0'
gem 'rails', '~> 8.1.0'
gem 'sassc-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'packs-rails'
gem 'packwerk'
gem 'packwerk-extensions'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'bcrypt'
gem 'date_validator'
gem 'faraday-retry'
gem 'kaminari'
gem 'nkf'
gem 'nokogiri'
gem 'rails-i18n'
gem 'valid_email2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.10'
  gem 'pry-rails'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'capybara-playwright-driver'
  gem 'danger-packwerk'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
end
