# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController::MatchupChartAction do
  let(:action) do
    described_class.new(
      ActionController::Parameters.new(
        described_class.model_name.param_key => { character:, battle_type:, period: PeriodSearchable::PERIODS[period] }
      ),
      player_sid:,
      character:
    )
  end
  let(:player_sid) { generate(:player_sid) }
  let(:period) { :day }
  let(:character) { 1 }
  let(:battle_type) { 1 }

  describe '#matchup_chart' do
    subject(:matchup_chart) { action.matchup_chart }

    it { is_expected.to respond_to(:fetch) }
  end
end
