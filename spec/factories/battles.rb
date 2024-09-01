FactoryBot.define do
  factory :battle do
    battle_type { 1 }
    replay_id
    played_at { '2023-06-02 12:00:00' }

    transient do
      p1 { build(:p1, battle: nil) }
      p2 { build(:p2, battle: nil) }

      after(:create) do |battle, ctx|
        ctx.p1.update!(battle:)
        ctx.p2.update!(battle:)
      end
    end
  end
end
