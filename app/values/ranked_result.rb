RankedResult = Data.define(:replay_id, :played_at, :master_rating,
  :mr_variation, :league_point) do
  def mr_variated?
    mr_variation.present?
  end

  def calibration?
    league_point.negative?
  end
end
