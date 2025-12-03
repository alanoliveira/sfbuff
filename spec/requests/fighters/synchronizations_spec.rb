require 'rails_helper'

RSpec.describe "/fighters/synchronizations" do
  describe "POST /create" do
    context "when the fighter is not synchronized" do
      it "returns http success" do
        post "/fighters/111222333/synchronization"
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the fighter is already synchronized" do
      it "returns http see_other" do
        create(:fighter_synchronization, :success, fighter: create(:fighter, id: 111222333))
        post "/fighters/111222333/synchronization"

        expect(response).to have_http_status(:see_other).and redirect_to(fighter_path(111222333))
      end
    end
  end
end
