class Fighter::Synchronizer::ProfileSynchronizer
  attr_reader :fighter, :buckler_gateway

  def initialize(fighter, buckler_gateway)
    @fighter = fighter
    @buckler_gateway = buckler_gateway
  end

  def synchronize
    fighter.profile = fetch_profile
  end

  private

  def fetch_profile
    buckler_gateway.find_fighter_profile(fighter.id) ||
      raise(Fighter::Synchronizer::ProfileNotFound)
  end
end
