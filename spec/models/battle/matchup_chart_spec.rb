# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::MatchupChart do
  subject(:matchup_chart) { Battle.pov.where(player: { player_sid: }).matchup_chart }

  let(:player_sid) { generate(:player_sid) }

  def have_matchup_data(data)
    include(Buckler::CHARACTERS.keys.index_with { |it| have_attributes(data[it]) if data[it].present? })
  end

  def add_many_matchups
    me = { player_sid: }
    create_list(:battle, 3, winner_side: 1, p1: me, p2: { character: 1, control_type: 0 })
    create_list(:battle, 2, winner_side: 2, p1: me, p2: { character: 1, control_type: 0 })
    create_list(:battle, 1, winner_side: nil, p1: me, p2: { character: 1, control_type: 0 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { character: 2, control_type: 0 })
    create_list(:battle, 4, winner_side: 1, p1: me, p2: { character: 1, control_type: 0 })
    create_list(:battle, 1, winner_side: 2, p1: me, p2: { character: 1, control_type: 1 })
  end

  def add_single_matchup
    create_list(:battle, 3, winner_side: 1, p1: { player_sid: }, p2: { character: 1, control_type: 0 })
  end

  describe '#each' do
    subject(:each) { matchup_chart.each }

    context 'with many matchups' do
      before { add_many_matchups }

      it do
        expect(each).to include(
          an_object_having_attributes(character: 1, control_type: 0, wins: 7, loses: 2, draws: 1, diff: 5, total: 10),
          an_object_having_attributes(character: 1, control_type: 1, wins: 0, loses: 1, draws: 0, diff: -1, total: 1),
          an_object_having_attributes(character: 2, control_type: 0, wins: 4, loses: 0, draws: 0, diff: 4, total: 4)
        )
      end
    end
  end

  describe '#sum' do
    subject(:sum) { matchup_chart.sum }

    context 'with many matchups' do
      before { add_many_matchups }

      it { is_expected.to have_attributes(total: 15) }
    end

    context 'with a single matchup' do
      before { add_single_matchup }

      it { is_expected.to have_attributes(total: 3) }
    end
  end
end
