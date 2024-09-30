class Players::BattlesFilterForm < BaseForm
  model_name.route_key = "player_battles"
  model_name.param_key = ""

  attribute :player_short_id
  attribute :character
  attribute :control_type
  attribute :vs_character
  attribute :vs_control_type
  attribute :battle_type
  attribute :played_from, :date
  attribute :played_to, :date

  validates :player_short_id, :character, :played_from, :played_to, presence: true

  def submit
    return Matchup.none unless valid?

    Matchup.where(matchup_criteria)
  end

  private

  def matchup_criteria
    {
      battle: battle_criteria,
      home_challenger: home_challenger_criteria,
      away_challenger: away_challenger_criteria
    }.compact_blank
  end

  def battle_criteria
    {
      played_at: (played_from.beginning_of_day..played_to.end_of_day),
      battle_type:
    }.compact_blank
  end

  def home_challenger_criteria
    {
      short_id: player_short_id,
      character:,
      control_type:
    }.compact_blank
  end

  def away_challenger_criteria
    {
      character: vs_character,
      control_type: vs_control_type
    }.compact_blank
  end
end
