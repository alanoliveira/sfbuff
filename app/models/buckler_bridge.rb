class BucklerBridge
  class Error < StandardError; end
  class PlayerNotFound < Error; end

  attr_reader :client

  def initialize(client: Buckler)
    @client = client
  end

  def battle_list(short_id:)
    validate_short_id!(short_id)

    Buckler::BattlelogIterator.new(next_api:, short_id:)
      .lazy.map { |raw_data| Parsers::BattleParser.parse(raw_data:) }
  end

  def fighter_banner(short_id:)
    validate_short_id!(short_id)

    raw_data = next_api.fighterslist(short_id:).first
    raise PlayerNotFound if raw_data.nil?

    parse_fighter_banner(raw_data)
  end

  def search_fighter_banner(term:)
    raise ArgumentError if term.length < 4

    result = next_api.fighterslist(fighter_id: term)
    if validate_short_id(term)
      next_api.fighterslist(short_id: term).first.try { result << _1 }
    end

    result.map do |raw_data|
      parse_fighter_banner(raw_data)
    end
  end

  private

  def next_api
    client.next_api(locale:)
  end

  def locale
    case I18n.locale
    when :ja then "ja-jp"
    when :'pt-BR' then "pt-br"
    else "en"
    end
  end

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
