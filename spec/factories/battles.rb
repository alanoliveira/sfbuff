FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    replay_id
    played_at { '2023-06-02 12:00:00' }
    challengers { [ p1, p2 ] }
    traits_for_enum(:battle_type, Buckler::Enums::BATTLE_TYPES)

    transient do
      p1 { build(:p1, battle: nil) }
      p2 { build(:p2, battle: nil) }
    end
  end
end
