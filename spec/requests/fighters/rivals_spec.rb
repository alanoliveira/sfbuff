require 'rails_helper'

RSpec.describe "fighters/:fighter_id/rivals" do
  let(:fighter) { create(:fighter) }

  include_context "with timezone cookie set"

  describe "GET /show" do
    it "returns http success" do
      get "/fighters/#{fighter.id}/rivals"
      expect(response).to have_http_status(:ok)
    end
  end
end
