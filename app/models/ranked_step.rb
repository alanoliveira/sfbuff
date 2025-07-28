class RankedStep < ApplicationRecord
  scope :calibrating, -> { where(mr: 0, lp: -1) }

  def readonly?
    true
  end
end
