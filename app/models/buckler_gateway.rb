class BucklerGateway
  def find_fighter_profile(fighter_id)
    data = buckler_credential.with_client { |cli| cli.fighter.search(short_id: fighter_id) }
    data.first.try { FighterProfileParser.parse(it) }
  end

  def search_fighter_profile(name)
    data = buckler_credential.with_client { |cli| cli.fighter.search(fighter_id: name) }
    data.map { FighterProfileParser.parse(it) }
  end

  def fetch_fighter_battles(fighter_id, page)
    data = buckler_credential.with_client { |cli| cli.fighter.battlelog(fighter_id, page) }
    data.map { BattleParser.parse(it) }
  end

  private

  def buckler_credential
    @buckler_credential ||= BucklerCredential.take
  end
end
