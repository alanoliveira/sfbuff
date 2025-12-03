module BucklerApiGateway::Mappers
  class PlayerInfo < BaseMapper
    def short_id
      dig("player", "short_id")
    end

    def fighter_id
      dig("player", "fighter_id")
    end

    def character_id
      dig("character_id")
    end

    def playing_character_id
      dig("playing_character_id")
    end

    def battle_input_type
      dig("battle_input_type")
    end

    def master_rating
      dig("master_rating")
    end

    def league_point
      dig("league_point")
    end

    def round_results
      dig("round_results")
    end
  end
end
