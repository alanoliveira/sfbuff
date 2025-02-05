class Fighter::Synchronizer::ProfileSynchronizer
  attr_reader :fighter

  def initialize(fighter)
    @fighter = fighter
  end

  def synchronize
    fighter.profile = fetch_profile
  end

  private

  def fetch_profile
    BucklerGateway.find_fighter_profile!(fighter.id)
  end
end
