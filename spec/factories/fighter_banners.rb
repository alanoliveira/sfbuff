FactoryBot.define do
  factory :fighter_banner do
    name { "Player #{short_id}" }
    short_id
    main_character { 1 }
    master_rating { 2000 }
    league_point { 10_000 }
  end
end
