class Parsers::FighterBannerParser < Parsers::BaseParser
  def parse
    {
      name: raw_data.dig("personal_info", "fighter_id"),
      short_id:  raw_data.dig("personal_info", "short_id"),
      main_character: raw_data["favorite_character_id"],
      master_rating: raw_data.dig("favorite_character_league_info", "master_rating"),
      league_point: raw_data.dig("favorite_character_league_info", "league_point"),
      home_id: raw_data.dig("home_id"),
      last_play_at: Time.at(raw_data.dig("last_play_at"))
    }.then { FighterBanner.new _1 }
  end
end
