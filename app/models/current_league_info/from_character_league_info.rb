module CurrentLeagueInfo::FromCharacterLeagueInfo
  extend ActiveSupport::Concern

  def from_character_league_info(character_league_info)
    self[:character_id] = character_league_info.character_id
    self[:mr] = character_league_info.master_rating
    self[:lp] = character_league_info.league_point

    self
  end
end
