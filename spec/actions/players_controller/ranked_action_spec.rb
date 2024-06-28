# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController::RankedAction do
  let(:action) do
    described_class.new(
      ActionController::Parameters.new(
        described_class.model_name.param_key => { character:, period: PeriodSearchable::PERIODS[period] }
      ),
      player_sid:,
      character:
    )
  end
  let(:player_sid) { generate(:player_sid) }
  let(:character) { 1 }

  before do
    diamond = { master_rating: 0 }
    master = { master_rating: 2000 }
    me = { player_sid:, character:, master_rating: 2000, league_point: 100 }

    # valid data
    create(:battle, :ranked, played_at: 1.hour.ago, p1: me.merge(mr_variation: 10), p2: master)
    create(:battle, :ranked, played_at: 6.days.ago, p1: me.merge(mr_variation: 10), p2: master)
    create(:battle, :ranked, played_at: 29.days.ago, p1: me.merge(mr_variation: 10), p2: master)
    create(:battle, :ranked, played_at: 1.hour.ago, p1: me, p2: diamond)

    # dirty data
    create(:battle, :ranked, played_at: 2.months.ago, p1: me.merge(mr_variation: 10), p2: master)
    create(:battle, :ranked, played_at: 1.hour.ago, p1: me.merge(mr_variation: 10, character: 2), p2: master)
    create(:battle, :ranked, played_at: 1.hour.ago, p1: master.merge(player_sid: generate(:player_sid)), p2: master)
    create(:battle, :ranked, played_at: 1.hour.ago, p1: me.merge(league_point: -1), p2: diamond)
  end

  describe '#master_rating' do
    subject(:master_rating) { action.master_rating }

    context 'with day period' do
      let(:period) { :day }

      it { is_expected.to have_attributes(count: 1) }
    end

    context 'with period "week"' do
      let(:period) { :week }

      it { is_expected.to have_attributes(count: 2) }
    end

    context 'with period "month"' do
      let(:period) { :month }

      it { is_expected.to have_attributes(count: 3) }
    end
  end

  describe '#league_point' do
    subject(:league_point) { action.league_point }

    context 'with day period' do
      let(:period) { :day }

      it { is_expected.to have_attributes(count: 2) }
    end

    context 'with period "week"' do
      let(:period) { :week }

      it { is_expected.to have_attributes(count: 3) }
    end

    context 'with period "month"' do
      let(:period) { :month }

      it { is_expected.to have_attributes(count: 4) }
    end
  end
end
