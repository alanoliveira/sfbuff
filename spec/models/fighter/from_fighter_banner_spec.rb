require 'rails_helper'

RSpec.describe Fighter::FromFighterBanner do
  let(:fighter) { Fighter.new.from_fighter_banner(fighter_banner) }
  let(:fighter_banner) do
    instance_double(BucklerApiGateway::Mappers::FighterBanner,
      short_id: 123456789,
      fighter_id: "PlayerABC",
      favorite_character_id: 100,
    )
  end

  it { expect(fighter.id).to eq 123456789 }
  it { expect(fighter.name).to eq "PlayerABC" }
  it { expect(fighter.main_character_id).to eq 100 }
end
