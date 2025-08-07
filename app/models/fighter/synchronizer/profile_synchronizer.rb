class Fighter::Synchronizer::ProfileSynchronizer
  attr_reader :fighter, :buckler_gateway

  def initialize(fighter, buckler_gateway)
    @fighter = fighter
    @buckler_gateway = buckler_gateway
  end

  def synchronize
    buckler_gateway.fetch_fighter_play_data(fighter.id) => { play_data:, fighter_profile: }

    fighter.profile = FighterProfile.new(fighter_profile)
    fighter.character_league_infos.upsert_all(play_data[:character_league_infos])
  end
end
