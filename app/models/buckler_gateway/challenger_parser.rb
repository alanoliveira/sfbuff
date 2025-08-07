class BucklerGateway::ChallengerParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    {
      fighter_id:,
      name:,
      character_id:,
      playing_character_id:,
      input_type_id:,
      mr:,
      lp:,
      round_ids:
    }
  end

  private

  attr_reader :raw_data

  def fighter_id
    player_data["short_id"]
  end

  def name
    player_data["fighter_id"]
  end

  def character_id
    raw_data["character_id"]
  end

  def playing_character_id
    raw_data["playing_character_id"]
  end

  def input_type_id
    raw_data["battle_input_type"]
  end

  def mr
    raw_data["master_rating"]
  end

  def lp
    raw_data["league_point"]
  end

  def round_ids
    raw_data["round_results"]
  end

  def player_data
    raw_data["player"] || {}
  end
end
