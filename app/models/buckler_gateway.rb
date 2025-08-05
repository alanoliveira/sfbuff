class BucklerGateway
  include Singleton

  class << self
    delegate_missing_to :instance
  end

  attr_accessor :buckler_connection

  def find_fighter_profile(fighter_id)
    buckler_client.search_fighters(short_id: fighter_id).first.try { FighterProfileParser.parse(it) }
  end

  def search_fighter_profile(name)
    buckler_client.search_fighters(fighter_id: name).map { FighterProfileParser.parse(it) }
  end

  def fetch_fighter_battles(fighter_id, page)
    buckler_client.fighter_battlelog(fighter_id, page).map { BattleParser.parse(it) }
  end

  private

  def buckler_client
    buckler_connection.client
  end
end
