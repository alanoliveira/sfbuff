class Players::RankedFilterForm < BaseForm
  model_name.route_key = ""
  model_name.param_key = ""

  attr_accessor :player
  attribute :character
  attribute :played_from, :date, default: -> { 7.days.ago }
  attribute :played_to, :date, default: -> { Time.zone.now }

  def submit
    RankedHistory.new(
      short_id: @player.short_id,
      character:,
      played_at:)
  end

  private

  def default_attributes
    { character: player.main_character }
  end

  def played_at
    (played_from.beginning_of_day..played_to.end_of_day)
  end
end
