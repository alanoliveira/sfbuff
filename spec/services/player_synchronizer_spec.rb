# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerSynchronizer do
  let(:player_synchronizer) { described_class.new(player_sid: player.sid, api:) }

  let(:api) { spy }
  let(:battles) { create_list(:battle, 3) }
  let(:player) { create(:player) }

  before do
    fighter_banner_importer = spy
    battlelog_importer = spy
    allow(FighterBannerImporter).to receive(:new).and_return(fighter_banner_importer)
    allow(BattlelogImporter).to receive(:new).and_return(battlelog_importer)
    allow(fighter_banner_importer).to receive(:call).and_return(player)
    allow(battlelog_importer).to receive(:call).and_return(battles)
  end

  describe '#call' do
    it 'updates the player synchronized_at' do
      expect { player_synchronizer.call }.to change(player, :synchronized_at)
    end

    it 'updates the player latest_replay_id' do
      expect { player_synchronizer.call }
        .to change(player, :latest_replay_id).to(battles.first.replay_id)
    end

    context 'when there is no new battles' do
      let(:battles) { [] }

      it 'do not updates the player latest_replay_id' do
        expect { player_synchronizer.call }.not_to change(player, :latest_replay_id)
      end
    end

    context 'when the player not exists' do
      before { allow(api).to receive(:search_player_by_sid).and_return(nil) }

      it 'raises a PlayerNotFoundError' do
        expect { player_synchronizer.call }.to raise_error(PlayerSynchronizer::PlayerNotFoundError)
      end
    end
  end
end
