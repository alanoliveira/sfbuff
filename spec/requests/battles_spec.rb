# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/players' do
  describe 'GET /battles/:replay_id' do
    context 'when the battle exists' do
      let(:battle) { create(:battle) }

      it 'renders a successful response' do
        get(battle_path(battle))
        expect(response).to be_successful
      end

      it 'renders the battle' do
        get(battle_path(battle))
        expect(response.body).to include(battle.replay_id)
      end
    end

    context 'when the battle do not exists' do
      let(:battle) { build(:battle) }

      it 'renders a not_found response' do
        get(battle_path(battle))
        expect(response).to have_http_status :not_found
      end
    end
  end
end
