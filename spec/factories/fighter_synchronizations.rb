FactoryBot.define do
  factory :fighter_synchronization do
    fighter
    status { "created" }

    traits_for_enum :status, FighterSynchronization.statuses
  end
end
