FactoryBot.define do
  factory :fighter_profile do
    fighter_id { generate(:fighter_id) }
    name { "Fighter##{fighter_id}" }
    main_character_id { 1 }
    mr { 1000 }
    lp { 10_000 }
    last_online_at { "2025-01-29 19:58:12" }
    home_id { 1 }
  end
end
