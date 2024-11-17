class BucklerBridge
  class Error < StandardError; end
  class PlayerNotFound < Error; end

  cattr_accessor :buckler_client, default: Buckler::Api

  attr_reader :next_client

  def initialize(next_client: nil)
    @next_client = next_client || buckler_client.next_client(locale:)
  end

  def battle_list(short_id:)
    next_client.battle_list(short_id).lazy.map { |raw_data| Parsers::BattleParser.parse(raw_data:) }
  end

  def fighter_banner(short_id:)
    raw_data = next_client.find_fighter_banner(short_id)
    raise PlayerNotFound if raw_data.nil?

    parse_fighter_banner(raw_data)
  end

  def search_fighter_banner(term:)
    next_client.search_fighter_banner(term).map do |raw_data|
      parse_fighter_banner(raw_data)
    end
  end

  private

  def locale
    case I18n.locale
    when :ja then "ja-jp"
    when :'pt-BR' then "pt-br"
    else "en"
    end
  end

  def parse_fighter_banner(raw_data)
    Parsers::FighterBannerParser.parse(raw_data:)
  end
end
