require 'rails_helper'

RSpec.describe Challenger::JoinVs, type: :model do
  subject(:join_vs) { Challenger.join_vs }

  before do
    create(:battle, p1: build(:p1, character: 1), p2: build(:p2, character: 2))
    create(:battle, p1: build(:p1, character: 3), p2: build(:p2, character: 1))
    create(:battle, p1: build(:p1, character: 2), p2: build(:p2, character: 1))
  end

  it "filters by vs criteria" do
    expect(join_vs.where(vs: { character: 2 }).count).to eq(2)
  end
end
