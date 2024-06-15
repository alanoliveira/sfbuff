# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::MatchupChart do
  subject(:matchup_chart) { Battle.pov.where(player: { player_sid: }).matchup_chart }

  let(:player_sid) { generate(:player_sid) }

  def have_matchup_data(data)
    include(Buckler::CHARACTERS.keys.index_with { |it| have_attributes(data[it]) if data[it].present? })
  end

  before do
    me = { player_sid: }
    create_list(:battle, 3, winner_side: 1, p1: me, p2: { character: 1 })
    create_list(:battle, 2, winner_side: 2, p1: me, p2: { character: 1 })
    create_list(:battle, 1, winner_side: nil, p1: me, p2: { character: 1 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { character: 2 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { character: 1 })
  end

  describe '#fetch' do
    subject(:fetch) { matchup_chart.fetch }

    it do
      expect(fetch).to have_matchup_data(
        ryu: { character: 1, wins: 7, loses: 2, draws: 1, diff: 5, total: 10 },
        luke: { character: 2, wins: 4, loses: 0, draws: 0, diff: 4, total: 4 }
      )
    end
  end

  describe '#sum' do
    subject(:sum) { matchup_chart.sum }

    it { is_expected.to have_attributes(character: nil, wins: 11, loses: 2, draws: 1, diff: 9, total: 14) }
  end
end
