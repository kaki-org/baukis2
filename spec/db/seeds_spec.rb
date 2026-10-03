# frozen_string_literal: true

require 'rails_helper'

# db/seeds.rb は Rails.root.glob が返す Pathname を扱う。
# String#split('/') 前提のままだと ArgumentError になり、また同一パック内の
# 依存順はファイル名順に依存するため、ここではその契約を固定する。
RSpec.describe 'development seed の読み込み契約', type: :task do
  describe 'パック seed の Pathname 取り扱い' do
    it 'Rails.root.glob の結果からパック名を取り出せる' do
      seed_files = Rails.root.glob('packs/*/db/seeds/development/*.rb')
      expect(seed_files).not_to be_empty
      expect(seed_files).to all(be_a(Pathname))

      pack_names = seed_files.map do |seed_file|
        seed_file.relative_path_from(Rails.root).each_filename.to_a[1]
      end

      expect(pack_names.uniq).to include('admin', 'customer', 'staff')
    end
  end

  describe 'staff パックの seed 読み込み順' do
    it 'staff_members が staff_events より先に来る' do
      staff_seeds = Rails.root.glob('packs/staff/db/seeds/development/*.rb').map { |p| p.basename.to_s }

      members_index = staff_seeds.index { |name| name.include?('staff_members') }
      events_index = staff_seeds.index { |name| name.include?('staff_events') }

      expect(members_index).to be_present
      expect(events_index).to be_present
      expect(members_index).to be < events_index
    end
  end
end
