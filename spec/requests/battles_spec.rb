require 'rails_helper'

RSpec.describe "/battles" do
  include_context "with timezone cookie set"

  describe "GET /battles/:replay_id" do
    it "returns http success" do
      battle = create(:battle)
      get "/battles/#{battle.replay_id}"
      expect(response).to have_http_status(:ok)
    end
  end
end
