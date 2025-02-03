require 'rails_helper'

RSpec.describe "Battles", type: :request do
  let(:battle) { create(:battle, :with_challengers) }

  describe "GET /battles/:replay_id" do
    it "returns a http ok response" do
      get battle_url(battle)
      expect(response).to have_http_status(:ok)
    end
  end
end
