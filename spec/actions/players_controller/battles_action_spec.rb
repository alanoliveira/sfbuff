# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController::BattlesAction do
  let(:action) { described_class.new(ActionController::Parameters.new(params), player:) }
  let(:player) { spy }

  describe '#battles' do
    subject(:battles) { action.battles }

    let(:params) do
      {
        player_character: 1,
        player_control_type: 2,
        opponent_character: 3,
        opponent_control_type: 4,
        battle_type: 5,
        played_from: '2000-01-01 00:00:00',
        played_to: '2000-01-02 00:00:00'
      }
    end

    let(:expected_params) do
      {
        player: { character: 1, control_type: 2 },
        opponent: { character: 3, control_type: 4 },
        battle_type: 5,
        played_at: a_range_covering(Time.utc(2000, 1, 1), Time.utc(2000, 1, 2).end_of_day)
      }
    end

    it do
      action.battles
      expect(player).to have_received(:where).with(expected_params)
    end
  end
end
