require "rails_helper"

RSpec.describe Battle::FromReplay do
  let(:battle) { Battle.new.from_replay(replay) }
  let(:replay) do
    instance_double(BucklerApiGateway::Mappers::Replay,
      replay_id: "AAABBBCCC",
      replay_battle_type: 4,
      uploaded_at: "2020-01-01 12:34:56".to_datetime,
      player1_info: instance_double(BucklerApiGateway::Mappers::PlayerInfo,
        short_id: 123456788,
        fighter_id: "TEST_FIGHTER_1",
        round_results: [ 1, 1 ],
        character_id: 254,
        playing_character_id: 3,
        battle_input_type: 0,
        master_rating: 2000,
        league_point: 30000
      ),
      player2_info: instance_double(BucklerApiGateway::Mappers::PlayerInfo,
        short_id: 123456789,
        fighter_id: "TEST_FIGHTER_2",
        round_results: [ 0, 0 ],
        character_id: 1,
        playing_character_id: 1,
        battle_input_type: 1,
        master_rating: 5000,
        league_point: 60000
      )
    )
  end

  it { expect(battle.replay_id).to eq "AAABBBCCC" }
  it { expect(battle.battle_type_id).to eq 4 }
  it { expect(battle.played_at).to eq "2020-01-01 12:34:56".to_datetime }
  it { expect(battle.p1_fighter_id).to eq 123456788 }
  it { expect(battle.p1_name).to eq "TEST_FIGHTER_1" }
  it { expect(battle.p1_rounds).to eq [ Round[1], Round[1] ] }
  it { expect(battle.p1_character_id).to eq 254 }
  it { expect(battle.p1_playing_character_id).to eq 3 }
  it { expect(battle.p1_input_type_id).to eq 0 }
  it { expect(battle.p1_mr).to eq 2000 }
  it { expect(battle.p1_lp).to eq 30000 }
  it { expect(battle.p2_fighter_id).to eq 123456789 }
  it { expect(battle.p2_name).to eq "TEST_FIGHTER_2" }
  it { expect(battle.p2_rounds).to eq [ Round[0], Round[0] ] }
  it { expect(battle.p2_character_id).to eq 1 }
  it { expect(battle.p2_playing_character_id).to eq 1 }
  it { expect(battle.p2_input_type_id).to eq 1 }
  it { expect(battle.p2_mr).to eq 5000 }
  it { expect(battle.p2_lp).to eq 60000 }
end
