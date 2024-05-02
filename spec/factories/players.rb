# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    name { 'MyString' }
    sid { 123_456_789 }
    latest_replay_id { nil }
    synchronized_at { nil }
  end
end
