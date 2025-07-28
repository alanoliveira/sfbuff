class BucklerGateway::FighterProfileParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    FighterProfile.new(
      fighter_id:,
      name:,
      main_character_id:,
      mr:,
      lp:,
      home_id:,
      last_online_at:,
    )
  end

  private

  attr_reader :raw_data

  def fighter_id
    personal_info["short_id"]
  end

  def name
    personal_info["fighter_id"]
  end

  def main_character_id
    raw_data["favorite_character_id"]
  end

  def mr
    favorite_character_league_info["master_rating"]
  end

  def lp
    favorite_character_league_info["league_point"]
  end

  def home_id
    raw_data["home_id"]
  end

  def last_online_at
    raw_data["last_play_at"].try { Time.at(it) }
  end

  def favorite_character_league_info
    raw_data["favorite_character_league_info"] || {}
  end

  def personal_info
    raw_data["personal_info"] || {}
  end
end
