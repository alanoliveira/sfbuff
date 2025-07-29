class RankedStep < ApplicationRecord
  scope :calibrating, -> { where(mr: 0, lp: -1) }
  scope :not_calibrating, -> { calibrating.invert_where }

  def readonly?
    true
  end
end
