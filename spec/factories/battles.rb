FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    replay_id
    played_at { '2023-06-02 12:00:00' }
  end
end
