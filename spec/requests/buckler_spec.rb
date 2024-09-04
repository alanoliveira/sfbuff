require 'rails_helper'

RSpec.describe "Bucklers", type: :request do
  describe "GET /player_search" do
    it "returns http success" do
      get "/buckler/player_search"
      expect(response).to have_http_status(:success)
    end
  end
end
