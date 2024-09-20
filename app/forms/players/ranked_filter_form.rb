class Players::RankedFilterForm < BaseForm
  model_name.route_key = "player_ranked"
  model_name.param_key = ""

  attr_accessor :player
  attribute :character
  attribute :played_from, :date
  attribute :played_to, :date

  def submit
    RankedHistory.new(
      short_id: player.short_id,
      character:,
      played_at:)
  end

  def played_from
    super.presence || 7.days.ago.to_date
  end

  def played_to
    super.presence || Time.zone.now.to_date
  end

  def character
    super.presence || player.main_character
  end

  private

  def played_at
    (played_from.beginning_of_day..played_to.end_of_day)
  end
end
