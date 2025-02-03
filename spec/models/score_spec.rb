require 'rails_helper'

RSpec.describe Score, type: :model do
  describe "#hash" do
    it "is not related to the values" do
      expect(Score.new(win: 0, lose: 0, draw: 0).hash).not_to eq Score.new(win: 0, lose: 0, draw: 0).hash
    end
  end
end
