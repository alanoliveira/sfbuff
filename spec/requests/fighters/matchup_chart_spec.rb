require 'rails_helper'

RSpec.describe "fighters/:fighter_id/matchup_chart" do
  let(:fighter) { create(:fighter) }

  include_context "with timezone cookie set"

  describe "GET /show" do
    context "when matchup_chart is not empty" do
      before do
        create(:battle, p1_fighter_id: fighter.id)
      end

      it "returns http success" do
        get "/fighters/#{fighter.id}/matchup_chart"
        expect(response).to have_http_status(:ok)
      end
    end

    context "when matchup_chart is empty" do
      it "returns http success" do
        get "/fighters/#{fighter.id}/matchup_chart"
        expect(response).to have_http_status(:ok)
      end

      it "renders a 'no data' alert" do
        get "/fighters/#{fighter.id}/matchup_chart"
        expect(response.body).to have_css("[data-test-id=no-data-alert]")
      end
    end
  end
end
