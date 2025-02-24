class Challenger < ApplicationRecord
  include Sti
  include Scoring

  composed_of :league_info, mapping: { league_point: :lp, master_rating: :mr }
  lookup_enum :character
  lookup_enum :playing_character, class_name: "Character"
  lookup_enum :input_type

  before_commit { MatchupIndex.index(self) }
  before_save { self.played_at = battle.played_at }

  delegate :result, to: :round_set

  def round_set
    RoundSet.new(round_ids)
  end
end
