# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FighterBannerImporter do
  subject(:fighter_banner_importer) { described_class.new(fighter_banner:) }

  let(:fighter_id) { 'fighter1' }
  let(:short_id) { 123_456_789 }
  let(:main_character) { 1 }
  let(:fighter_banner) do
    {
      'favorite_character_id' => main_character,
      'personal_info' => {
        'fighter_id' => fighter_id,
        'short_id' => short_id
      }
    }
  end

  describe '#call' do
    it 'returns the player' do
      expect(fighter_banner_importer.call).to have_attributes(sid: short_id)
    end

    context 'when the player do not exists' do
      it 'creates a new player' do
        expect { fighter_banner_importer.call }.to change(Player, :count).by(1)
      end
    end

    context 'when the player already exists' do
      before do
        create(:player, sid: short_id, name: 'old_name', main_character: 2)
      end

      it 'updates the player data' do
        expect { fighter_banner_importer.call }.to change { Player.find(short_id).attributes }
          .to(a_hash_including('name' => fighter_id, 'main_character' => 1))
      end
    end
  end
end
