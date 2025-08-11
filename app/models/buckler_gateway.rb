class BucklerGateway
  attr_reader :buckler_credential

  def initialize(buckler_credential: nil)
    @buckler_credential = buckler_credential || BucklerCredential.take
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

  def search_fighter_profile(name: nil, fighter_id: nil)
    unless name.nil? ^ fighter_id.nil?
      raise ArgumentError, "name XOR fighter_id is required"
    end

    buckler_credential.with_client do |cli|
      # yep, in the API the name is the fighter_id and
      # the numeric id is short_id
      cli.fighter.search(fighter_id: name, short_id: fighter_id)
    end.map { FighterProfileParser.parse(it) }
  end
end
