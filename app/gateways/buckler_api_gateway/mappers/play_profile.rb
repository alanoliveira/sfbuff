module BucklerApiGateway::Mappers
  class PlayProfile < BaseMapper
    def fighter_banner
      FighterBanner.new(dig("fighter_banner_info"))
    end

    def character_league_infos
      dig("play", "character_league_infos").map do
        CharacterLeagueInfo.new(it)
      end
    end
  end
end
