FactoryBot.define do
  factory :player do
    name { "Player #{short_id}" }
    short_id
    main_character { 1 }
    latest_replay_id { nil }
    synchronized_at { nil }
  end
end
