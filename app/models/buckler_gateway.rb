class BucklerGateway
  def find_fighter_profile(fighter_id)
    data = buckler_credential.with_client { |cli| cli.fighter.search(short_id: fighter_id) }
    data.first.try { FighterProfileParser.parse(it) }
  end

  def search_fighter_profile_by_name(name)
    search_fighter_profile(fighter_id: name)
  end

  def search_fighter_profile_by_id(fighter_id)
    return [] unless Fighter::FIGHTER_ID_REGEXP.match? fighter_id.to_s
    search_fighter_profile(short_id: fighter_id)
  end

  def fetch_fighter_battles(fighter_id, page)
    data = buckler_credential.with_client { |cli| cli.fighter.battlelog(fighter_id, page) }
    data.map { BattleParser.parse(it) }
  end

  def fetch_fighter_play_data(fighter_id)
    data = buckler_credential.with_client { |cli| cli.fighter.play_data(fighter_id) }

    play_data = PlayDataParser.parse(data["play"])
    fighter_profile = FighterProfileParser.parse(data["fighter_banner_info"])
    { play_data:, fighter_profile: }
  end

  private

  def search_fighter_profile(**)
    data = buckler_credential.with_client { |cli| cli.fighter.search(**) }
    data.map { FighterProfileParser.parse(it) }
  end

  def buckler_credential
    @buckler_credential ||= BucklerCredential.take
  end
end
