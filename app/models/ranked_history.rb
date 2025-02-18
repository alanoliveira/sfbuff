class RankedHistory
  include ActiveModel::Model
  include ActiveModel::Attributes
  include Enumerable

  Item = Data.define(:replay_id, :played_at, :master_rating, :league_point,
    :master_rating_variation, :league_point_variation)

  attribute :fighter_id
  attribute :character
  attribute :played_from, :date, default: -> { 7.days.ago.to_date }
  attribute :played_to, :date, default: -> { Time.zone.now.to_date }

  validates :fighter_id, :character, :played_from, :played_to, presence: true

  def each(&)
    data = fetch_data
    return data if data.empty?

    fetch_data.chain([ nil ]).each_cons(2).filter_map do |a, b|
      unless b.nil?
        # handle MR reset
        if b["mr"].zero? ^ a["mr"].zero?
          b["mr"] = a["mr"] = [ a["mr"], b["mr"] ].max
        end
        mr_variation = b["mr"] - a["mr"]
        lp_variation = b["lp"] - a["lp"]
      end
      played_at = a["played_at"].in_time_zone(Time.zone)
      Item.new(a["replay_id"], played_at, a["mr"], a["lp"], mr_variation, lp_variation)
    end.each(&)
  end

  def cache_key
    ActiveSupport::Cache.expand_cache_key([ model_name.cache_key, Digest::MD5.hexdigest(attributes.to_param) ])
  end

  def cache_version
    nil
  end

  private

  def fetch_data
    return [] unless valid?

    binds = [ fighter_id, character.to_i, Battle.battle_types["ranked"],
      played_from.beginning_of_day, played_to.end_of_day ]
    ApplicationRecord.lease_connection.select_all(<<~SQL, "#{__FILE__}:#{__LINE__}", binds)
      SELECT replay_id, home.played_at, home.master_rating mr, home.league_point lp
      FROM challengers home
      INNER JOIN battles ON home.battle_id = battles.id
      WHERE home.fighter_id = $1 AND home.character_id = $2 AND home.league_point >= 0
      AND   battles.battle_type = $3 AND home.played_at BETWEEN $4 AND $5
      ORDER BY home.played_at
    SQL
  end
end
