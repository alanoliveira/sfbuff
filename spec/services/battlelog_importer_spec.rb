# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BattlelogImporter do
  subject(:battlelog_importer) { described_class.new(battlelog) }

  let(:battlelog) { [] }

  before do
    allow(Parsers::BattlelogParser).to receive(:parse) { |data| data }
  end

  describe '#import_while!' do
    let(:battlelog) { build_list(:battle, 5) }

    it 'returns the new battles' do
      expect(battlelog_importer.import_while! { true }).to have_attributes(count: 5)
    end

    it 'import the new battles' do
      expect do
        battlelog_importer.import_while! { |b| b.replay_id != battlelog[2].replay_id }
      end.to change(Battle, :count).by(2)
    end

    it 'ignores if the battle already was imported by the opponent' do
      battlelog[0].save
      expect do
        battlelog_importer.import_while! { |b| b.replay_id != battlelog[2].replay_id }
      end.to change(Battle, :count).by(1)
    end
  end
end
