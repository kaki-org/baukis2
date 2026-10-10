# frozen_string_literal: true

require 'English'
require 'rails_helper'

RSpec.describe 'Rails 8 での Packwerk 互換性', type: :system do
  describe 'オートローディング' do
    it 'パック間の依存関係が正しく動作する' do
      # staff パックが customer パックに依存していることを確認
      staff_package = YAML.load_file('packs/staff/package.yml')
      expect(staff_package['dependencies']).to include('packs/customer')
    end

    it 'customer パックは shared 以外に依存しない' do
      customer_package = YAML.load_file('packs/customer/package.yml')
      expect(customer_package['dependencies']).to eq(['packs/shared'])
    end

    # packwerk-extensions (Packwerk::Privacy::Checker) と同じく先頭 5 行を同じ正規表現で判定する。
    # 違反がないことは packwerk check で担保し、ここでは公開 API の一覧を固定する
    def pack_public_files(pack_path)
      Dir.glob("#{pack_path}/**/*.rb").select do |path|
        File.foreach(path).first(5).any? { |line| line.match?(/#.*pack_public:\s*true/) }
      end
    end

    it 'customer パックの公開 API が pack_public で宣言されている' do
      expect(pack_public_files('packs/customer')).to contain_exactly(
        'packs/customer/app/models/address.rb',
        'packs/customer/app/models/customer.rb',
        'packs/customer/app/models/phone.rb',
        'packs/customer/app/presenters/address_form_presenter.rb',
        'packs/customer/app/presenters/address_presenter.rb',
        'packs/customer/app/presenters/customer_form_presenter.rb',
        'packs/customer/app/presenters/customer_presenter.rb'
      )
    end

    it 'shared パックの公開 API が pack_public で宣言されている' do
      expect(pack_public_files('packs/shared')).to contain_exactly(
        'packs/shared/app/controllers/application_controller.rb',
        'packs/shared/app/lib/html_builder.rb',
        'packs/shared/app/models/application_record.rb',
        'packs/shared/app/models/concerns/email_holder.rb',
        'packs/shared/app/models/concerns/password_holder.rb',
        'packs/shared/app/models/concerns/personal_name_holder.rb',
        'packs/shared/app/models/concerns/string_normalizer.rb',
        'packs/shared/app/presenters/form_presenter.rb',
        'packs/shared/app/presenters/model_presenter.rb',
        'packs/shared/app/presenters/user_form_presenter.rb'
      )
    end

    it 'shared パックは他パックに依存しない' do
      shared_package = YAML.load_file('packs/shared/package.yml')
      expect(shared_package['dependencies']).to be_nil
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
      %w[packs/admin packs/staff packs/customer packs/shared].each do |pack_path|
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
      expect(root_package['dependencies']).to eq(['packs/shared'])
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
