class RankedHistory
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include Enumerable

  Result = Struct.new(:mr, :lp, :mr_variation, :lp_variation, :played_at, :replay_id)

  attr_accessor :fighter, :character_id, :played_at

  def initialize(fighter, character_id: nil, played_at: nil)
    @fighter = fighter
    @character_id = character_id || fighter.main_character_id
    @played_at = played_at || ..Time.zone.now
  end

  delegate :each, :empty?, to: :data

  private

  def data
    @data ||= begin
      matches_on_period.chain([ future_item ]).each_cons(2).map do |first, second|
        if second.present?
          mr_variation = second["home_mr"] - first["home_mr"]
          lp_variation = second["home_lp"] - first["home_lp"]
        end
        Result.new(
          played_at: first["played_at"],
          replay_id:  first["replay_id"],
          mr: first["home_mr"],
          lp: first["home_lp"],
          mr_variation:,
          lp_variation:,
        )
      end
    end
  end

  def future_item
    if (mr, lp = future_item_from_matches || future_item_from_current_league_info)
      { "home_mr"=> mr, "home_lp" => lp }
    end
  end

  def future_item_from_current_league_info
    fighter.current_league_infos[character_id]&.values_at(:mr, :lp)
  end

  def future_item_from_matches
    if last_match_on_period = matches_on_period.last
      matches.where("played_at > ?", last_match_on_period.played_at).pick(:home_mr, :home_lp)
    end
  end

  def matches_on_period
    matches.where(played_at:)
  end

  def matches
    @fighter
      .matches
      .ranked
      .where(home_character_id: character_id)
      .order("played_at")
      .select("home_mr", "home_lp", "replay_id", "played_at")
  end
end
