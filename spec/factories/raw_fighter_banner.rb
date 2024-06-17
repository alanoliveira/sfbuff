# frozen_string_literal: true

FactoryBot.define do
  factory :raw_favorite_character_league_info, class: Hash do
    skip_create
    initialize_with { attributes }
    after(:build, &:stringify_keys!)

    league_point { 123_456 }
    master_rating { 2000 }
  end

  factory :raw_personal_info, class: Hash do
    skip_create
    initialize_with { attributes }
    after(:build, &:stringify_keys!)

    fighter_id { Faker::Games::Dota.hero }
    short_id { generate(:player_sid) }
  end

  factory :raw_fighter_banner, class: Hash do
    skip_create
    initialize_with { attributes }
    after(:build, &:stringify_keys!)

    favorite_character_id { 1 }
    home_name { Faker::Address.country }
    favorite_character_name { Faker::Games::StreetFighter.character }
    favorite_character_league_info { association :raw_favorite_character_league_info }
    personal_info { association :raw_personal_info }
  end
end
