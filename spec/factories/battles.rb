FactoryBot.define do
  factory :battle do
    replay_id
    battle_type { "casual_match" }
    played_at { "2024-10-10 12:00:00" }

    trait :with_challengers do
      p1 { build(:p1) }
      p2 { build(:p2) }
    end
  end
end
