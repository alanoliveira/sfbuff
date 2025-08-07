class BucklerGateway::PlayDataParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    { character_league_infos: }
  end

  private

  attr_reader :raw_data
  def character_league_infos
    raw_data["character_league_infos"].map do
      BucklerGateway::CharacterLeagueInfoParser.parse it
    end
  end
end
