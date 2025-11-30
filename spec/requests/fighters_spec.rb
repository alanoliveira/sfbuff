require 'rails_helper'

RSpec.describe "/fighters" do
  describe "POST /synchronize" do
    context "when the fighter is not synchronized" do
      it "returns http success" do
        post "/fighters/111222333/synchronize"
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the fighter is already synchronized" do
      it "returns http see_other" do
        create(:fighter_synchronization, :success, fighter: create(:fighter, id: 111222333))
        post "/fighters/111222333/synchronize", headers: { accept: "text/vnd.turbo-stream.html", referer: fighter_path(111222333) }

        expect(response).to have_http_status(:see_other).and redirect_to(fighter_path(111222333))
      end
    end
  end
end
