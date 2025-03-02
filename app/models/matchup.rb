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

  def home_challengers
    Challenger.with(matchup:).joins(<<~JOIN)
      INNER JOIN matchup ON matchup.home_challenger_id = challengers.id
    JOIN
  end

  def away_challengers
    Challenger.with(matchup:).joins(<<~JOIN)
      INNER JOIN matchup ON matchup.away_challenger_id = challengers.id
    JOIN
  end

  def battles
    Battle.with(matchup:).joins(<<~JOIN)
      INNER JOIN matchup ON matchup.battle_id = battles.id
    JOIN
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

  def matchup
    return MatchupCache.none unless valid?

    Arel.sql(<<~SQL)
      SELECT * FROM (
        (#{cached_matchups.to_sql})
        UNION ALL
        (#{uncached_matchups.to_sql})
      )
    SQL
  end

  def cached_matchups
    MatchupCache.select("home_challenger_id, away_challenger_id, battle_id, played_at").tap do
      it.where!(played_at: played_from.beginning_of_day..played_to.end_of_day)
      it.where!(battle_type:) if battle_type.present?
      it.where!(home_fighter_id:) if home_fighter_id.present?
      it.where!(home_character_id: home_character) if home_character.present?
      it.where!(home_input_type_id: home_input_type) if home_input_type.present?
      it.where!(away_fighter_id:) if away_fighter_id.present?
      it.where!(away_character_id: away_character) if away_character.present?
      it.where!(away_input_type_id: away_input_type) if away_input_type.present?
    end
  end

  def uncached_matchups
    last_cached_battle_id = MatchupCache.maximum(:battle_id)
     battles_rel
      .by_matchup(home: home_rel, away: away_rel)
      .tap { it.where!("battles.id > ?", last_cached_battle_id) if last_cached_battle_id }
      .select("home.id home_challenger_id", "away.id away_challenger_id", "battles.id battle_id", "battles.played_at")
  end

  def battles_rel
    return Battle.none unless valid?

    Battle.all.tap do
      it.where!(battle_type:) if battle_type.present?
      it.where!(played_at: played_from.beginning_of_day..played_to.end_of_day)
    end
  end

  def home_rel
    Challenger.all.tap do
      it.where!(fighter_id: home_fighter_id) if home_fighter_id.present?
      it.where!(character: home_character) if home_character.present?
      it.where!(input_type: home_input_type) if home_input_type.present?
    end
  end

  def away_rel
    Challenger.all.tap do
      it.where!(fighter_id: away_fighter_id) if away_fighter_id.present?
      it.where!(character: away_character) if away_character.present?
      it.where!(input_type: away_input_type) if away_input_type.present?
    end
  end
end
