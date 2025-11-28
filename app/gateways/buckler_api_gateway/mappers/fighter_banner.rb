module BucklerApiGateway::Mappers
  class FighterBanner < BaseMapper
    extend ActiveModel::Translation

    def short_id
      dig("personal_info", "short_id")
    end

    def fighter_id
      dig("personal_info", "fighter_id")
    end

    def favorite_character_id
      dig("favorite_character_id")
    end

    def master_rating
      dig("favorite_character_league_info", "master_rating")
    end

    def league_point
      dig("favorite_character_league_info", "league_point")
    end

    def home_id
      dig("home_id")
    end

    def last_play_at
      dig("last_play_at").try { Time.zone.at(it) }
    end
  end
end
