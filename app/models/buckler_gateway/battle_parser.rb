class BucklerGateway::BattleParser
  def self.parse(raw_data)
    new(raw_data).parse
  end

  def initialize(raw_data)
    @raw_data = raw_data
  end

  def parse
    Battle.new(
      replay_id:,
      battle_type_id:,
      played_at:,
      p1:,
      p2:,
    )
  end

  private

  attr_reader :raw_data

  def p1
    BucklerGateway::ChallengerParser.parse(raw_data.fetch("player1_info"))
  end

  def p2
    BucklerGateway::ChallengerParser.parse(raw_data.fetch("player2_info"))
  end

  def replay_id
    raw_data["replay_id"]
  end

  def battle_type_id
    raw_data["replay_battle_type"]
  end

  def played_at
    raw_data["uploaded_at"].presence.try { Time.at(it) }
  end
end
