# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players' do
  describe 'GET /players/:sid' do
    context 'when the player exists' do
      let(:player) { create(:player) }

      it 'renders a successful response' do
        get players_url(player)
        expect(response).to be_successful
      end

      it 'renders the player-sync div' do
        get player_url(player)
        expect(response.body).to match_xpath("//div[@id='player-sync']")
      end
    end

    context 'when the player do not exists' do
      let(:player) { build(:player) }

      it 'renders the player-sync div' do
        get player_url(player)
        expect(response.body).to match_xpath("//div[@id='player-sync']")
      end

      it 'renders a successful response' do
        get player_url(player)
        expect(response).to be_successful
      end
    end
  end
end
