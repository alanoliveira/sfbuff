module Fighter::FromFighterBanner
  extend ActiveSupport::Concern

  def from_fighter_banner(fighter_banner)
    self[:id] = fighter_banner.short_id
    self[:name] = fighter_banner.fighter_id
    self[:main_character_id] = fighter_banner.favorite_character_id

    self
  end
end
