class RankedHistory
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include Enumerable

  Item = Struct.new(:mr, :lp, :mr_variation, :lp_variation, :played_at, :replay_id)

  attr_reader :fighter, :character_id, :played_from, :played_to

  def initialize(fighter, character_id: nil, played_from: nil, played_to: nil)
    @fighter = fighter
    @character_id = character_id || fighter.main_character_id
    @played_from = played_from
    @played_to = played_to
  end

  delegate :each, :empty?, to: :data

  private

  def data
    @data ||= fetch_matches.map do |match|
      Item.new(
        played_at: match.played_at,
        replay_id:  match.replay_id,
        mr: match.home_mr,
        lp: match.home_lp,
        mr_variation: match.home_mr_variation,
        lp_variation: nil,
      )
    end
  end

  def fetch_matches
    fighter
      .matches
      .ranked
      .where(played_at: played_from..played_to, home_character_id: character_id)
      .order("played_at")
      .select("home_mr", "home_lp", "away_mr", "result", "battle_type_id", "replay_id", "played_at")
  end
end
