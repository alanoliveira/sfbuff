FactoryBot.define do
  factory :player_synchronize_process do
    short_id { nil }
    imported_battles_count { nil }
    error { nil }
    started_at { nil }
    finished_at { nil }
  end
end
