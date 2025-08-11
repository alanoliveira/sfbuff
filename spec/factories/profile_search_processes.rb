FactoryBot.define do
  factory :profile_search_process do
    query { "MyString" }

    traits_for_enum(:status)
  end
end
