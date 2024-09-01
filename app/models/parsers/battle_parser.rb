class Parsers::BattleParser < Parsers::BaseParser
  def parse
    Battle.new(parse_battle).tap do |battle|
      battle.challengers << Challenger.new(parse_p1)
      battle.challengers << Challenger.new(parse_p2)
    end
  end

  private

  def parse_battle
    {
      replay_id: raw_data.fetch("replay_id"),
      battle_type: raw_data.fetch("replay_battle_type"),
      played_at: Time.at(raw_data.fetch("uploaded_at")).utc.to_datetime
    }
  end

  def parse_p1
    parse_player(raw_data.fetch("player1_info")).merge(side: 1)
  end

  def parse_p2
    parse_player(raw_data.fetch("player2_info")).merge(side: 2)
  end

  def parse_player(raw_player)
    {
      short_id: raw_player.fetch("player").fetch("short_id"),
      name: raw_player.fetch("player").fetch("fighter_id"),
      character: raw_player.fetch("character_id"),
      playing_character: raw_player.fetch("playing_character_id"),
      control_type: raw_player.fetch("battle_input_type"),
      master_rating: raw_player.fetch("master_rating"),
      league_point: raw_player.fetch("league_point"),
      rounds: raw_player.fetch("round_results")
    }
  end
end
