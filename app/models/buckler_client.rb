class BucklerClient < ApplicationRecord
  def battle_list(short_id:)
    client.replay_list(short_id:).lazy.map do |raw_data|
      Parsers::BattleParser.parse(raw_data:)
    end
  end

  def fighter_banner(short_id:)
    raw_data = client.fighter_banner.player_fighter_banner(short_id:)
    parse_fighter_banner(raw_data)
  end

  def search_fighter_banner(term:)
    client.fighter_banner.search_fighter_banner(term:).map do |raw_data|
      parse_fighter_banner(raw_data)
    end
  end

  private

  def parse_fighter_banner(raw_data)
    Parsers::FighterBannerParser.parse(raw_data:)
  end

  def client
    @client ||= Buckler::Api::Client.new(cookies:, build_id:)
  end
end
