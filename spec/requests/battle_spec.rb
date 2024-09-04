require 'rails_helper'

RSpec.describe "Battles", type: :request do
  before { create(:battle, replay_id: "TEST1234") }

  describe "GET /battles/:replay_id" do
    it "returns http success" do
      get "/battles/TEST1234"
      expect(response).to have_http_status(:success)
    end

    context "when the battle does not exist" do
      it "returns http success" do
        get "/battles/TEST1111"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
