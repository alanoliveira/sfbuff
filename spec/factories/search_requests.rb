FactoryBot.define do
  factory :search_request do
    query { "MyString" }
    status { 1 }
    result { "" }
    error { "MyString" }
  end
end
