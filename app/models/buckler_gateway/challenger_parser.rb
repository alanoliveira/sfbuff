class BucklerGateway::ChallengerParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    Challenger.new(
      fighter_id:,
      name:,
      character_id:,
      playing_character_id:,
      input_type_id:,
      master_rating:,
      league_point:,
      round_ids:
    )
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
    Character.find_or_create_by!(id: raw_data["character_id"]) do |char|
      char.name = raw_data["character_tool_name"]
    end.id
  end

  def playing_character_id
    Character.find_or_create_by!(id: raw_data["playing_character_id"]) do |char|
      char.name = raw_data["playing_character_tool_name"]
    end.id
  end

  def input_type_id
    raw_data["battle_input_type"]
  end

  def master_rating
    raw_data["master_rating"]
  end

  def league_point
    raw_data["league_point"]
  end

  def round_ids
    raw_data["round_results"]
  end

  def player_data
    raw_data["player"] || {}
  end
end
