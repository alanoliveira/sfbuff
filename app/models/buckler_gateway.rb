module BucklerGateway
  extend self

  cattr_accessor :client, default: BucklerApi, instance_accessor: false

  def fighter_banners(short_id: nil, query: nil)
    short_id, fighter_id = short_id.try { ShortId.new(_1) }, query
    client.fighterslist(short_id:, fighter_id:).map do |raw_data|
      Parsers::FighterBannerParser.parse(raw_data:)
    end
  end

  def battles(short_id)
    short_id = ShortId.new(short_id)
    BucklerApi::BattlelogIterator.new(client, short_id)
      .lazy.map { |raw_data| Parsers::BattleParser.parse(raw_data:) }
  end
end
