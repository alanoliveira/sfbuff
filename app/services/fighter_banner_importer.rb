# frozen_string_literal: true

class FighterBannerImporter
  def initialize(fighter_banner)
    @fighter_banner = fighter_banner
  end

  def import!
    player.name = @fighter_banner.dig('personal_info', 'fighter_id')
    player.tap(&:save!)
  end

  private

  def player
    @player ||= Player.find_or_initialize_by(
      sid: @fighter_banner.dig('personal_info', 'short_id')
    )
  end
end
