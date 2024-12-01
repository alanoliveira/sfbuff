FactoryBot.define do
  factory :battle do
    battle_type { BattleType["custom_room"] }
    replay_id
    played_at { '2023-06-02 12:00:00' }
    traits_for_enum(:battle_type, BattleType.to_h { [ _1.to_s, _1 ] })
    challengers { [ p1.dup, p2.dup ] }

    transient do
      p1 { build(:p1) }
      p2 { build(:p2) }
    end
  end
end
