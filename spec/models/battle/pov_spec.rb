# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Battle::Pov do
  subject(:pov) { Battle.pov }

  it do
    expect(pov.joins_values).to include(
      a_string_including('AS player'),
      a_string_including('AS opponent')
    )
  end

  describe '#rivals' do
    subject(:rivals) { pov.rivals }

    before { create_list(:battle, 5) }

    it do
      expect(rivals).to have_attributes(count: 10).and all(
        have_attributes(group: a_hash_including('name', 'player_sid', 'character', 'control_type'))
      )
    end
  end

  describe '#matchup_chart' do
    subject(:matchup_chart) { pov.matchup_chart }

    it do
      Buckler::CHARACTERS.values.product(Buckler::CONTROL_TYPES.values).each do |character, control_type|
        expect(matchup_chart).to include(
          an_object_having_attributes(group: { 'character' => character, 'control_type' => control_type })
        )
      end
    end
  end
end
