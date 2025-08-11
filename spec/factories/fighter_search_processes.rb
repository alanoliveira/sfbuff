FactoryBot.define do
  factory :fighter_search_process do
    query { "MyString" }

    traits_for_enum(:status)
  end
end
