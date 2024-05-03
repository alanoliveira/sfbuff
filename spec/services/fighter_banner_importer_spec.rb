# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FighterBannerImporter do
  subject(:fighter_banner_importer) { described_class.new(fighter_banner) }

  let(:fighter_id) { 'fighter1' }
  let(:short_id) { 123_456_789 }
  let(:fighter_banner) do
    {
      'personal_info' => {
        'fighter_id' => fighter_id,
        'short_id' => short_id
      }
    }
  end

  describe '#import!' do
    context 'when the player do not exists' do
      it 'creates a new player' do
        expect { fighter_banner_importer.import! }.to change(Player, :count).by(1)
      end
    end

    context 'when the player already exists' do
      before do
        create(:player, sid: short_id, name: 'old_name')
      end

      it 'updates the player name' do
        expect { fighter_banner_importer.import! }.to change { Player.find(short_id).name }.to(fighter_id)
      end
    end
  end
end
