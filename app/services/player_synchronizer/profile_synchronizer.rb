class PlayerSynchronizer::ProfileSynchronizer < ApplicationService
  attr_reader :player

  def initialize(player:)
    @player = player
  end

  def run
    fighter_banner = FighterBanner.find!(player.short_id)
    player.assign_attributes(fighter_banner.attributes.slice("name", "main_character"))
  end
end
