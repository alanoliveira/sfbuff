# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '' do
  let(:player) { create(:player) }

  before do
    driven_by(:rack_test)
  end

  context 'when a user visits player battles page' do
    before do
      create(:battle, played_at: 3.minutes.ago, p1: { player_sid: player.sid })
      create(:battle, played_at: 1.minute.ago, p1: { player_sid: player.sid })
      create(:battle, played_at: 2.minutes.ago, p1: { player_sid: player.sid })
      create_list(:battle, 10, played_at: 1.day.ago, p1: { player_sid: player.sid })
    end

    it 'displays the battle counter alert' do
      visit player_battles_url(player)

      expect(page).to have_css('.alert', text: '13 matches found')
    end

    it 'displays the rivals panel' do
      visit player_battles_url(player)

      expect(page).to have_css('h3', text: 'Rivals')
    end

    it 'displays the battles at played_at desc order' do
      visit player_battles_url(player)

      all('#battle-list .card').each_cons(2) do |a, b|
        expect(a.find('.card-header .text-center>span').native.get_attribute('title').to_time)
          .to be >= b.find('.card-header .text-center>span').native.get_attribute('title').to_time
      end
    end
  end
end
