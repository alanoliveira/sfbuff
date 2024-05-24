# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players' do
  let(:player) { create(:player) }

  RSpec::Matchers.define :has_player_sync_div do
    match { |subject| values_match?(match_xpath("//div[@id='player-sync']"), subject) }
    failure_message { 'body do not contains the player sync div' }
    failure_message_when_negated { 'body should not contains the player sync div' }
  end

  shared_examples 'a layout/players page' do
    context 'when player exists and is synchronized' do
      let(:player) { create(:player, :synchronized) }

      it do
        expect(response.body).not_to has_player_sync_div if response.successful?
      end
    end

    context 'when player exists but not synchronized' do
      let(:player) { create(:player, :desynchronized) }

      it do
        expect(response.body).to has_player_sync_div if response.successful?
      end
    end

    context 'when player do not exists' do
      let(:player) { build(:player) }

      it do
        expect(response.body).to has_player_sync_div if response.successful?
      end
    end
  end

  describe 'GET /players/:sid' do
    it_behaves_like 'a layout/players page' do
      before { get player_url(player) }
    end

    it do
      get player_url(player)
      expect(response).to redirect_to(battles_player_url(player))
    end
  end

  describe 'GET /players/:sid/battles' do
    it_behaves_like 'a layout/players page' do
      before { get battles_player_url(player) }
    end

    it do
      get battles_player_url(player)
      expect(response).to be_successful
    end

    it do
      get battles_player_url(player)
      expect(response.body).to match_xpath('//h3[text()="Rivals"]')
    end

    it do
      get battles_player_url(player)
      expect(response.body).to match_xpath('//h3[text()="Matches"]')
    end

    context 'when player have no matches' do
      it 'render an alert with the number of battles found' do
        get battles_player_url(player)
        expect(response.body).to match_xpath('//div[@role="alert" and text()="No matches found"]')
      end
    end

    context 'when player have matches' do
      before do
        create(:battle, winner_side: 1, battle_type: 1, played_at: 1.minute.ago,
                        p1: { player_sid: player.sid, rounds: [0, 1, 2] },
                        p2: { rounds: [3, 4, 5] })

        create(:battle, winner_side: 2, battle_type: 2, played_at: 1.minute.ago,
                        p1: { player_sid: player.sid, rounds: [6, 7] },
                        p2: { rounds: [8, 8] })

        create(:battle, winner_side: nil, battle_type: 3, played_at: 1.minute.ago,
                        p1: {},
                        p2: { player_sid: player.sid })

        create(:battle, battle_type: 4, played_at: 1.minute.ago,
                        p1: {},
                        p2: { player_sid: player.sid })
      end

      it 'render an alert with the number of battles found' do
        get battles_player_url(player)
        expect(response.body).to match_xpath('//div[@role="alert" and text()="4 matches found"]')
      end
    end
  end
end
