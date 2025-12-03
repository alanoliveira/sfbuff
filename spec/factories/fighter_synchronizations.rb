FactoryBot.define do
  factory :fighter_synchronization do
    fighter { nil }
    status { 1 }

    traits_for_enum :status, FighterSynchronization.statuses
  end
end
