require "rails_helper"

RSpec.describe Battle, type: :model do
  it { expect(create(:battle, :ranked, p1: create(:p1, :master), p2: create(:p2, :master))).to be_a_master_battle }
  it { expect(create(:battle, :battle_hub, p1: create(:p1, :master), p2: create(:p2, :master))).not_to be_a_master_battle }
  it { expect(create(:battle, :ranked, p1: create(:p1, :diamond), p2: create(:p2, :master))).not_to be_a_master_battle }
end
