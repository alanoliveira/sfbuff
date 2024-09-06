FactoryBot.define do
  factory :buckler_client do
    build_id { "MyString" }
    cookies { "MyString" }
    traits_for_enum :status, BucklerClient.statuses
    ok
  end
end
