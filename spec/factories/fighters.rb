FactoryBot.define do
  factory :fighter do
    id { generate(:short_id) }
    name { "Fighter##{id}" }
    main_character_id { 1 }
  end
end
