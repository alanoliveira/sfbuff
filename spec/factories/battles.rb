# frozen_string_literal: true

FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    traits_for_enum :battle_type, Buckler::BATTLE_TYPES
    played_at { 1.minute.ago }
    replay_id

    transient do
      p1 { attributes_for(:p1) }
      p2 { attributes_for(:p2) }
    end

    after(:build) do |battle, context|
      battle.challengers = [
        build(:p1, battle:, **context.p1),
        build(:p2, battle:, **context.p2)
      ]
    end
  end
end
