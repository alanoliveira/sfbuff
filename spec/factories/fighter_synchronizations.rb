FactoryBot.define do
  factory :fighter_synchronization, class: "Fighter::Synchronization" do
    fighter
    status { "created" }

    traits_for_enum :status, Fighter::Synchronization.statuses
  end
end
