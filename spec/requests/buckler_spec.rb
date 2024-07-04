# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/buckler' do
  describe 'GET /player_search' do
    context 'without q parameter' do
      it 'renders a successful response' do
        get buckler_player_search_url(q: '')
        expect(response).to be_successful
      end

      it 'not renders the stream source PlayerSearchChannel' do
        get buckler_player_search_url(q: '')
        expect(response.body).not_to have_stream_source('PlayerSearchChannel')
      end
    end

    context 'when a search parameter is sent' do
      it 'renders a successful response' do
        get buckler_player_search_url(q: 'search')
        expect(response).to be_successful
      end

      it 'renders the player-search component' do
        get buckler_player_search_url(q: 'search')
        expect(response.body).to have_stream_source('PlayerSearchChannel')
      end
    end
  end
end
