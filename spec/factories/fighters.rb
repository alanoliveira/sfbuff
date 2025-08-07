FactoryBot.define do
  factory :fighter do
    id { generate(:fighter_id) }

    trait :unsynchronized do
      synchronized_at { Fighter::Synchronizable::SYNCHRONIZATION_THRESHOLD.ago }
    end

    trait :synchronized do
      synchronized_at { Time.zone.now }
    end
  end
end
