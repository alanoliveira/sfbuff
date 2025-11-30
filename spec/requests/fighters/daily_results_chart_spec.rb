require 'rails_helper'

RSpec.describe "fighters/:fighter_id/daily_results_chart" do
  let(:fighter) { create(:fighter) }

  describe "GET /show" do
    before do
      create(:battle, p1_fighter_id: fighter.id)
    end

    it "returns http success" do
      get "/fighters/#{fighter.id}/daily_results_chart"
      expect(response).to have_http_status(:ok)
    end
  end
end
