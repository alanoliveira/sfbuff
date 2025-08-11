class FighterSearchProcess < ApplicationRecord
  include Clearable

  enum :status, { "created" => 0, "subscribed" => 1, "finished" => 2 }
  attribute :result, default: []

  validates :query, length: { minimum: 4 }
  normalizes :query, with: ->(query) { query.strip.titlecase }
end
