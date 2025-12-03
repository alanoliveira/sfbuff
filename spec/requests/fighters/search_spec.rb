require 'rails_helper'

RSpec.describe "fighters/search" do
  include_context "with timezone cookie set"

  describe "GET /show" do
    it "returns http success" do
      get "/fighters/search"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post "/fighters/search/player"
      expect(response).to have_http_status(:ok)
    end
  end
end
