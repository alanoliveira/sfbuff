FactoryBot.define do
  factory :battle do
    replay_id
    battle_type { "casual_match" }
    played_at { "2024-10-10 12:00:00" }
  end
end
