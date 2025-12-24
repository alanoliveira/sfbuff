class Fighter::Synchronization::ProfileSynchronizer
  attr_reader :fighter

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    synchronize_fighter_banner
    synchronize_current_league
  end

  private

  def synchronize_fighter_banner
    fighter.from_fighter_banner(play_profile.fighter_banner).save
  end

  def synchronize_current_league
    play_profile.character_league_infos.each do |character_league_info|
      current_league = fighter.current_leagues[character_league_info.character_id] || fighter.current_leagues.new
      current_league.from_character_league_info(character_league_info).save
    end
  end

  def play_profile
    @play_profile ||= BucklerApiGateway.fetch_fighter_play_profile(fighter.id)
  end
end
