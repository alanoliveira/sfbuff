class PlayerSynchronizer < ApplicationService
  class PlayerNotFound < StandardError; end

  attr_reader :player

  def initialize(player:)
    @player = player
  end

  def run
    player.with_lock do
      next if player.synchronized?

      fighter_banner = FighterBanner.find(player.short_id)
      raise PlayerNotFound if fighter_banner.nil?

      BattlesSynchronizer.run(player:)

      player.assign_attributes(fighter_banner.attributes.slice("name", "main_character"))
      player.synchronized_at = Time.zone.now
      player.save!
    end
  end
end
