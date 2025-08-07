class BucklerGateway::CharacterLeagueInfoParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    { character_id:, mr:, lp: }
  end

  private

  attr_reader :raw_data

  def character_id
    raw_data["character_id"]
  end

  def mr
    raw_data.dig("league_info", "master_rating")
  end

  def lp
    raw_data.dig("league_info", "league_point")
  end
end
