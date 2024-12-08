require 'rails_helper'

RSpec.describe "Battles", type: :request do
  describe "GET /battles/:replay_id" do
    it "returns http success" do
      battle = create(:battle)
      get battle_path(battle)
      expect(response).to have_http_status(:success)
    end

    context "when the battle does not exist" do
      it "returns http not found" do
        battle = build(:battle)
        get battle_path(battle)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
