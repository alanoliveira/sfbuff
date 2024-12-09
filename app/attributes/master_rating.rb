class MasterRating < NumericAttribute
  INITIAL_MASTER_RATING = 1500

  def self.initial_master_rating
    new(INITIAL_MASTER_RATING)
  end

  def to_s
    "#{to_i} MR"
  end
end
