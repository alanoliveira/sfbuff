class RankedHistory::RankedStep < ApplicationRecord
  scope :sorted, -> { order(:played_at) }

  def readonly?
    true
  end
end
