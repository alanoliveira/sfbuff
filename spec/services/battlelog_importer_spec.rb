# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlelogImporter do
  subject(:battlelog_importer) { described_class.new(battlelog:, import_condition:) }

  let(:battlelog) { [] }
  let(:import_condition) { ->(_battle) { true } }

  before do
    allow(Parsers::BattlelogParser).to receive(:parse) { |data| data }
  end

  describe '#call' do
    let(:battlelog) { build_list(:battle, 5) }
    let(:import_condition) do
      ->(b) { b.replay_id != battlelog[2].replay_id }
    end

    it 'returns the new battles' do
      expect(battlelog_importer.call).to have_attributes(count: 2).and all(be_a(Battle))
    end

    it 'import the new battles' do
      expect { battlelog_importer.call }.to change(Battle, :count).by(2)
    end

    it 'ignores if the battle already was imported by the opponent' do
      battlelog[0].save
      expect do
        battlelog_importer.call { |b| b.replay_id != battlelog[2].replay_id }
      end.to change(Battle, :count).by(1)
    end
  end
end
