# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlelogImporter do
  subject(:battlelog_importer) { described_class.new(battlelog) }

  let(:battles) { [] }
  let(:short_id) { 123_456_789 }
  let(:battlelog) do
    instance_spy(Buckler::Api::Battlelog, lazy: battles, player_sid: short_id)
  end

  before do
    allow(Parsers::BattlelogParser).to receive(:parse) { |data| data }
  end

  describe '#import!' do
    let(:battles) { build_list(:battle, 5) }

    context 'when the player is not synchronized' do
      before do
        create(:player, sid: short_id, name: 'old_name', latest_replay_id: battles[2].replay_id)
      end

      it 'import the new battles' do
        expect { battlelog_importer.import! }.to change(Battle, :count).by(2)
      end

      it 'ignores if the battle already was imported by the opponent' do
        battles[0].save
        expect { battlelog_importer.import! }.to change(Battle, :count).by(1)
      end
    end

    context 'when the player is already synchronized' do
      before do
        player = create(:player, sid: short_id)
        allow(player).to receive(:synchronized?).and_return true
        allow(Player).to receive(:find).and_return(player)
      end

      it 'do not update the player data' do
        expect { battlelog_importer.import! }.not_to(change { Player.find(short_id) })
      end

      it 'do not import the new battles' do
        expect { battlelog_importer.import! }.not_to change(Battle, :count)
      end
    end
  end
end
