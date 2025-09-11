# frozen_string_literal: true

require 'English'
require 'rails_helper'

RSpec.describe 'Rails 8 での Packwerk 互換性', type: :system do
  describe 'オートローディング' do
    it 'パックベースモデルが正しく読み込まれる' do
      # Customer モデルが customer パックから正しく読み込まれることを確認
      # プライバシー違反を避けるため、定数の存在確認のみ行う
      expect(defined?(Customer)).to be_truthy
    end

    it 'パック間の依存関係が正しく動作する' do
      # staff パックが customer パックに依存していることを確認
      staff_package = YAML.load_file('packs/staff/package.yml')
      expect(staff_package['dependencies']).to include('packs/customer')
    end

    it 'プライバシー強制が正しく動作する' do
      # package_todo.yml にプライバシー違反が記録されていることを確認
      root_todo = YAML.load_file('package_todo.yml')
      expect(root_todo['packs/customer']).to be_present
      expect(root_todo['packs/customer']['::Address']['violations']).to include('privacy')
    end
  end

  describe 'ルーティング' do
    it 'パック固有のルートが正しく動作する' do
      # Rails ルーティングでパック固有のルートが読み込まれることを確認
      expect(Rails.application.routes.routes.map(&:name)).to include('staff_root')
      expect(Rails.application.routes.routes.map(&:name)).to include('admin_root')
      expect(Rails.application.routes.routes.map(&:name)).to include('customer_root')
    end

    it 'ホスト制約が正しく設定されている' do
      # ホスト制約が正しく設定されていることを確認
      staff_route = Rails.application.routes.routes.find { |r| r.name == 'staff_root' }
      expect(staff_route.constraints[:host]).to eq('baukis2.lvh.me')

      customer_route = Rails.application.routes.routes.find { |r| r.name == 'customer_root' }
      expect(customer_route.constraints[:host]).to eq('lvh.me')
    end
  end

  describe 'パック構造' do
    it '各パックが適切な package.yml を持つ' do
      %w[packs/admin packs/staff packs/customer].each do |pack_path|
        package_file = File.join(pack_path, 'package.yml')
        expect(File.exist?(package_file)).to be true

        package_config = YAML.load_file(package_file)
        expect(package_config['enforce_dependencies']).to be true
        expect(package_config['enforce_privacy']).to be true
      end
    end

    it 'ルートパッケージが適切に設定されている' do
      root_package = YAML.load_file('package.yml')
      expect(root_package['enforce_dependencies']).to be true
      expect(root_package['enforce_privacy']).to be true
      expect(root_package['dependencies']).to include('packs/customer')
    end
  end

  describe 'Packwerk コマンド' do
    it 'packwerk validate が成功する' do
      result = system('bundle exec packwerk validate > /dev/null 2>&1')
      expect(result).to be true
    end

    it 'packwerk check が違反なしを報告する' do
      # packwerk check を実行して、違反がないことを確認
      output = `bundle exec packwerk check 2>&1`
      expect($CHILD_STATUS.exitstatus).to eq(0) # 違反がないため 0 を返す
      expect(output).to include('No offenses detected')
    end
  end
end
