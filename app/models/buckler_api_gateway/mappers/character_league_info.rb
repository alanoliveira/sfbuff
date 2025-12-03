module BucklerApiGateway::Mappers
  class CharacterLeagueInfo < BaseMapper
    def character_id
      dig("character_id")
    end

    def league_point
      dig("league_info", "league_point")
    end

    def master_rating
      dig("league_info", "master_rating")
    end
  end
end
