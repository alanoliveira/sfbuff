class Matchup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :battle_type
  attribute :played_from, :date, default: -> { 7.days.ago.to_date }
  attribute :played_to, :date, default: -> { Time.zone.now.to_date }
  %w[home away].each do |kind|
    attribute "#{kind}_fighter_id"
    attribute "#{kind}_character"
    attribute "#{kind}_input_type"
  end

  validates :played_from, :played_to, presence: true

  def count
    matchup_index.count
  end

  def home_challengers
    Challenger.with(matchup_index:).joins(<<~JOIN)
      INNER JOIN matchup_index ON matchup_index.home_challenger_id = challengers.id
    JOIN
  end

  def away_challengers
    Challenger.with(matchup_index:).joins(<<~JOIN)
      INNER JOIN matchup_index ON matchup_index.away_challenger_id = challengers.id
    JOIN
  end

  def battles
    Battle.with(matchup_index:).joins(:matchup_index)
  end

  def rivals(limit)
    Rivals.new(self, limit)
  end

  def matchup_chart
    MatchupChart.new(self)
  end

  def cache_key
    ActiveSupport::Cache.expand_cache_key([ model_name.cache_key, Digest::MD5.hexdigest(attributes.to_param) ])
  end

  def cache_version
    nil
  end

  private

  def matchup_index
    return MatchupIndex.none unless valid?

    MatchupIndex.all.tap do
      it.where!(played_at: played_from.beginning_of_day..played_to.end_of_day)
      it.where!(battle_type:) if battle_type.present?
      it.where!(home_fighter_id:) if home_fighter_id.present?
      it.where!(home_character_id:  home_character) if home_character.present?
      it.where!(home_input_type_id:  home_input_type) if home_input_type.present?
      it.where!(away_fighter_id:) if away_fighter_id.present?
      it.where!(away_character_id:  away_character) if away_character.present?
      it.where!(away_input_type_id:  away_input_type) if away_input_type.present?
    end
  end
end
