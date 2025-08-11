class ProfileSearchProcess < ApplicationRecord
  include Clearable

  enum :status, { "created" => 0, "subscribed" => 1, "finished" => 2 }
  attribute :result, default: []

  validates :query, length: { minimum: 4 }
  normalizes :query, with: ->(query) { query.strip.titlecase }

  def subscribe!
    transaction do
      next false unless lock!.created?
      subscribed!
      SearchJob.perform_later(self)
    end
  end

  def search_now!
    return false unless subscribed?
    self.result = FighterProfile.search(query)
  ensure
    finished!
    broadcast_render
  end
end
