# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players/:sid/matchup_chart' do
  let(:player) { create(:player, name: 'Player Name', main_character: 10) }

  describe 'GET /players/:sid/matchup_chart' do
    it_behaves_like 'a layout/players page' do
      before { get player_matchup_chart_url(player) }
    end

    it 'renders a successful response' do
      get player_matchup_chart_url(player)
      expect(response).to be_successful
    end

    context 'when the player have battles' do
      before do
        create(:battle, played_at: Time.zone.now, p1: { player_sid: player.sid, character: player.main_character })
      end

      it 'render the matchup chart table' do
        get player_matchup_chart_url(player)
        expect(response).to have_rendered('players/matchup_charts/_table')
      end
    end

    context 'when the player have no battle' do
      it 'render filtered counter alert' do
        get player_matchup_chart_url(player)
        expect(response.body).to include('No match found')
      end

      it 'do not render battles' do
        get player_matchup_chart_url(player)
        expect(response).not_to have_rendered('players/matchup_chart/_table')
      end
    end
  end
end
