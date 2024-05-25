# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    battle_subtype { 1 }
    played_at { (Time.zone.local(2023, 1, 1) + rand(1.year.to_i)) }
    sequence :replay_id, 'FACBOTAAA'
    raw_data { 'raw_data' }

    transient do
      p1 { attributes_for(:p1) }
      p2 { attributes_for(:p2) }
    end

    after(:build) do |battle, context|
      battle.p1 = build(:p1, battle:, **context.p1) if context.p1.present?
      battle.p2 = build(:p2, battle:, **context.p2) if context.p2.present?
    end
  end
end
