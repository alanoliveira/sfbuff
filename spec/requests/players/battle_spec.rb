require 'rails_helper'

RSpec.describe "Players::Battles", type: :request do
  let(:player) { create(:player) }

  describe "GET /players/:player_id/battles" do
    it "returns http success" do
      get player_battles_path(player)
      expect(response).to have_http_status(:success)
    end

    context "when overflowing the page" do
      it "returns http success" do
        get player_battles_path(player, page: 2)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
