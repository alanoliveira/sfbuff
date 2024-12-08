require 'rails_helper'

RSpec.describe "Players::RankedHistories", type: :request do
  describe "GET /players/:short_id/ranked_history" do
    it "returns http success" do
      player = create(:player)
      get ranked_history_path(player)
      expect(response).to have_http_status(:success)
    end
  end
end
