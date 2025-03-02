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
    end.sort_by(&:played_at).each(&)
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

    Challenger
      .with(battles: Battle.ranked .where(played_at: played_from.beginning_of_day..played_to.end_of_day))
      .calibrated
      .where(fighter_id:, character:)
      .joins("INNER JOIN battles ON battles.id = challengers.battle_id")
      .select("battles.replay_id, battles.played_at, master_rating mr, league_point lp")
  end
end
