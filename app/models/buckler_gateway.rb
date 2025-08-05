class BucklerGateway
  def find_fighter_profile(fighter_id)
    buckler_credential.with_client { |cli| cli.fighter.search(short_id: fighter_id).first.try { FighterProfileParser.parse(it) } }
  end

  def search_fighter_profile(name)
    buckler_credential.with_client { |cli| cli.fighter.search(fighter_id: name).map { FighterProfileParser.parse(it) } }
  end

  def fetch_fighter_battles(fighter_id, page)
    buckler_credential.with_client { |cli| cli.fighter.battlelog(fighter_id, page).map { BattleParser.parse(it) } }
  end

  private

  def buckler_credential
    @buckler_credential ||= BucklerCredential.take
  end
end
