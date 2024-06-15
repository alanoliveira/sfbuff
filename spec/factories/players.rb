# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    name { 'MyString' }
    sid { generate(:player_sid) }
    main_character { 1 }
    latest_replay_id { nil }
    synchronized_at { nil }

    trait :synchronized do
      synchronized_at { Time.now.utc }
    end

    trait :desynchronized do
      synchronized_at { 1.year.ago }
    end
  end
end
