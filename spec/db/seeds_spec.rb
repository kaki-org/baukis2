# frozen_string_literal: true

require 'rails_helper'

# db/seeds.rb は Rails.root.glob が返す Pathname を扱う。
# パック名抽出は SeedPack.name_for に集約し、ここから実コードを検証する。
# 同一パック内の依存順はファイル名順（数字接頭辞）に依存するため、あわせて固定する。
RSpec.describe 'db/seeds.rb', type: :task do
  describe SeedPack do
    describe '.name_for' do
      it 'packs 配下の Pathname からパック名を返す' do
        seed_file = Rails.root.join('packs/staff/db/seeds/development/01_staff_members.rb')
        expect(described_class.name_for(seed_file)).to eq('staff')
      end

      it 'Rails.root.glob の結果からもパック名を取り出せる' do
        seed_files = Rails.root.glob('packs/*/db/seeds/development/*.rb')
        expect(seed_files).not_to be_empty
        expect(seed_files).to all(be_a(Pathname))

        pack_names = seed_files.map { |seed_file| described_class.name_for(seed_file) }
        expect(pack_names.uniq).to include('admin', 'customer', 'staff')
      end
    end
  end

  describe 'staff パックの seed 読み込み順' do
    it 'staff_members が staff_events より先に来る' do
      staff_seeds = Rails.root.glob('packs/staff/db/seeds/development/*.rb').sort.map { |p| p.basename.to_s }

      members_index = staff_seeds.index { |name| name.include?('staff_members') }
      events_index = staff_seeds.index { |name| name.include?('staff_events') }

      expect(members_index).not_to be_nil
      expect(events_index).not_to be_nil
      expect(members_index).to be < events_index
    end
  end
end
