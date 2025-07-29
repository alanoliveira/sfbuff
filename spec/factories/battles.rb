FactoryBot.define do
  factory :battle do
    replay_id
    battle_type_id { 4 }
    played_at { "2024-10-10 12:00:00" }
    p1 { build(:challenger) }
    p2 { build(:challenger) }
  end
end
