class BucklerBridge
  class Error < StandardError; end
  class PlayerNotFound < Error; end

  attr_reader :api

  def initialize(api: BucklerClient.take.api)
    @api = api
  end

  def battle_list(short_id:)
    validate_short_id!(short_id)

    api.replay_list(short_id:).lazy.map do |raw_data|
      Parsers::BattleParser.parse(raw_data:)
    end
  end

  def fighter_banner(short_id:)
    validate_short_id!(short_id)

    raw_data = api.fighter_banner.player_fighter_banner(short_id:)
    raise PlayerNotFound if raw_data.nil?

    parse_fighter_banner(raw_data)
  end

  def search_fighter_banner(term:)
    raise ArgumentError if term.length < 4
    fighter_banner = api.fighter_banner

    result = fighter_banner.search_fighter_banner(term:)
    if validate_short_id(term)
      fighter_banner.player_fighter_banner(short_id: term).try { result << _1 }
    end

    result.map do |raw_data|
      parse_fighter_banner(raw_data)
    end
  end

  private

  def validate_short_id(short_id)
    short_id.to_s[/\A\d{9,}\z/]
  end

  def validate_short_id!(short_id)
    raise ArgumentError unless validate_short_id(short_id)
  end

  def parse_fighter_banner(raw_data)
    Parsers::FighterBannerParser.parse(raw_data:)
  end
end
