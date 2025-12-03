FactoryBot.define do
  factory :synchronization_request do
    fighter_id { "" }
    status { 1 }
    result { "" }
    error { "MyString" }
  end
end
