# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    battle_subtype { 1 }
    played_at { (Time.zone.local(2023, 1, 1) + rand(1.year.to_i)) }
    sequence :replay_id, 'FACBOTAAA'
    raw_data { 'raw_data' }

    trait :with_challangers do
      # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
      transient do
        p1 { build(:challanger, player_sid: 123_456_789, side: 'p1', battle: nil) }
        p2 { build(:challanger, player_sid: 123_456_788, side: 'p2', battle: nil) }
      end
      # rubocop:enable FactoryBot/FactoryAssociationWithStrategy

      challangers { [p1, p2] }
    end
  end
end
